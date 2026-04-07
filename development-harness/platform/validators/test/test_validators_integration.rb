require "minitest/autorun"
require "open3"
require "tmpdir"
require "fileutils"

# ---------------------------------------------------------------------------
# Integration tests for harness validator shell scripts.
#
# These tests shell out to the actual validate-*.sh scripts against known-good
# and known-bad fixture projects. They verify that:
#   - Each validator exits 0 on valid input
#   - Each validator exits 1 and emits a specific error on invalid input
#   - Disabled-validation overrides are respected
#
# Requirements: Ruby 3.0+, bash
# Run: ruby -I development-harness/platform/validators/lib \
#           development-harness/platform/validators/test/test_validators_integration.rb
#
# These tests do NOT call git or external services — companion validation is
# tested via the unit test inline loop in test_harness_registry.rb.
# ---------------------------------------------------------------------------

SCRIPT_DIR   = File.expand_path("../../", __FILE__)       # platform/validators/
PLATFORM_DIR = File.expand_path("../", SCRIPT_DIR)        # platform/
FIXTURES_DIR = File.expand_path("fixtures/projects", File.dirname(__FILE__))

# Helper: run a validator script and return [stdout, stderr, exit_status]
def run_validator(script_name, *args)
  cmd = ["bash", File.join(SCRIPT_DIR, script_name), *args]
  stdout, stderr, status = Open3.capture3(*cmd)
  [stdout.strip, stderr.strip, status.exitstatus]
end

# Helper: path to a fixture project manifest
def fixture_manifest(project_name)
  File.join(FIXTURES_DIR, project_name, "harness.manifest.yaml")
end

# Helper: path to a fixture project root
def fixture_project(project_name)
  File.join(FIXTURES_DIR, project_name)
end

# ---------------------------------------------------------------------------
# validate-manifest.sh
# ---------------------------------------------------------------------------
class TestValidateManifest < Minitest::Test
  def test_valid_prototype_passes
    out, err, code = run_validator("validate-manifest.sh", fixture_manifest("valid-prototype"))
    assert_equal 0, code, "Expected exit 0. stderr: #{err}"
    assert_match(/✓/, out)
  end

  def test_broken_bad_schema_fails
    out, err, code = run_validator("validate-manifest.sh", fixture_manifest("broken-bad-schema"))
    assert_equal 1, code, "Expected exit 1. stdout: #{out}"
    assert_match(/schemaVersion must be 1/, err)
    assert_match(/project\.maturity is required/, err)
    assert_match(/project\.criticality is required/, err)
    assert_match(/unknown module groups/, err)
  end

  def test_missing_manifest_aborts
    _out, err, code = run_validator("validate-manifest.sh", "/nonexistent/harness.manifest.yaml")
    assert_equal 1, code
    assert_match(/not found|No such file/i, err)
  end
end

# ---------------------------------------------------------------------------
# validate-module-graph.sh
# ---------------------------------------------------------------------------
class TestValidateModuleGraph < Minitest::Test
  def test_valid_prototype_passes
    out, err, code = run_validator("validate-module-graph.sh", fixture_manifest("valid-prototype"))
    assert_equal 0, code, "Expected exit 0. stderr: #{err}"
    assert_match(/✓/, out)
  end

  def test_broken_bad_dependency_fails
    out, err, code = run_validator("validate-module-graph.sh", fixture_manifest("broken-bad-dependency"))
    assert_equal 1, code, "Expected exit 1. stdout: #{out}"
    assert_match(/depends on missing module project-standard/, err)
  end

  def test_broken_conflict_fails
    out, err, code = run_validator("validate-module-graph.sh", fixture_manifest("broken-conflict"))
    assert_equal 1, code, "Expected exit 1. stdout: #{out}"
    assert_match(/conflict/, err.downcase)
  end
end

# ---------------------------------------------------------------------------
# validate-required-artifacts.sh
# ---------------------------------------------------------------------------
class TestValidateRequiredArtifacts < Minitest::Test
  def test_valid_prototype_with_all_artifacts_passes
    out, err, code = run_validator(
      "validate-required-artifacts.sh",
      fixture_manifest("valid-prototype"),
      fixture_project("valid-prototype")
    )
    assert_equal 0, code, "Expected exit 0. stderr: #{err}"
    assert_match(/✓/, out)
  end

  def test_broken_missing_artifact_fails
    out, err, code = run_validator(
      "validate-required-artifacts.sh",
      fixture_manifest("broken-missing-artifact"),
      fixture_project("broken-missing-artifact")
    )
    assert_equal 1, code, "Expected exit 1. stdout: #{out}"
    assert_match(/missing/, err)
    assert_match(/docs\/product/, err)
  end

  def test_disabled_validation_exits_zero
    # Create a temporary manifest with required-artifacts disabled
    Dir.mktmpdir do |tmpdir|
      manifest_path = File.join(tmpdir, "harness.manifest.yaml")
      File.write(manifest_path, <<~YAML)
        schemaVersion: 1
        project:
          id: test-disabled
          name: Test Disabled
          maturity: prototype
          criticality: low
        modules:
          core:
            - kernel/base
          management:
            - product-lite
        overrides:
          requiredArtifacts: []
          disabledValidations:
            - required-artifacts
      YAML

      out, err, code = run_validator("validate-required-artifacts.sh", manifest_path, tmpdir)
      assert_equal 0, code, "Disabled validation should exit 0. stderr: #{err}"
      assert_match(/disabled/i, out)
    end
  end

  def test_artifact_missing_from_project_root_fails
    # Valid manifest but empty project directory — no artifact files exist
    Dir.mktmpdir do |tmpdir|
      out, err, code = run_validator(
        "validate-required-artifacts.sh",
        fixture_manifest("broken-missing-artifact"),
        tmpdir
      )
      assert_equal 1, code, "Expected exit 1 for missing artifacts. stdout: #{out}"
      assert_match(/missing/, err)
    end
  end
end

# ---------------------------------------------------------------------------
# validate-placeholders.sh
# Note: this validator takes only a project root (no manifest arg) — it scans
# all tracked files for [[PLACEHOLDER]] and YYYY-MM-DD tokens using ripgrep.
# These tests are skipped when ripgrep is not installed as a real binary.
# ---------------------------------------------------------------------------
RG_AVAILABLE = system("bash -c 'command -v rg >/dev/null 2>&1'")

class TestValidatePlaceholders < Minitest::Test
  def setup
    skip "ripgrep (rg) not installed as a real binary — skipping placeholder tests" unless RG_AVAILABLE
  end

  def test_no_placeholders_passes
    Dir.mktmpdir do |tmpdir|
      File.write(File.join(tmpdir, "README.md"), "No placeholders here.\n")

      out, err, code = run_validator("validate-placeholders.sh", tmpdir)
      assert_equal 0, code, "Expected exit 0. stderr: #{err}"
      assert_match(/✓/, out)
    end
  end

  def test_unfilled_bracket_placeholder_fails
    Dir.mktmpdir do |tmpdir|
      File.write(File.join(tmpdir, "docs.md"), "Owner: [[OWNER_NAME]]\n")

      out, _err, code = run_validator("validate-placeholders.sh", tmpdir)
      assert_equal 1, code, "Expected exit 1 for unfilled placeholder"
      assert_match(/OWNER_NAME/, out)
    end
  end

  def test_date_placeholder_fails
    Dir.mktmpdir do |tmpdir|
      File.write(File.join(tmpdir, "notes.md"), "Last reviewed: YYYY-MM-DD\n")

      out, _err, code = run_validator("validate-placeholders.sh", tmpdir)
      assert_equal 1, code, "Expected exit 1 for YYYY-MM-DD placeholder"
      assert_match(/YYYY-MM-DD/, out)
    end
  end

  def test_valid_prototype_fixture_passes
    # The valid-prototype fixture has only empty stub files — no placeholder tokens
    out, err, code = run_validator("validate-placeholders.sh", fixture_project("valid-prototype"))
    assert_equal 0, code, "Expected exit 0 for valid-prototype fixture. stderr: #{err}"
    assert_match(/✓/, out)
  end
end

# ---------------------------------------------------------------------------
# validate-agent-pack.sh
# ---------------------------------------------------------------------------
class TestValidateAgentPack < Minitest::Test
  def test_valid_prototype_with_agents_md_passes
    out, err, code = run_validator(
      "validate-agent-pack.sh",
      fixture_manifest("valid-prototype"),
      fixture_project("valid-prototype")
    )
    assert_equal 0, code, "Expected exit 0. stderr: #{err}"
    assert_match(/✓/, out)
  end

  def test_missing_agents_md_fails
    Dir.mktmpdir do |tmpdir|
      manifest_path = File.join(tmpdir, "harness.manifest.yaml")
      File.write(manifest_path, <<~YAML)
        schemaVersion: 1
        project:
          id: test-no-agents
          name: No Agents MD
          maturity: prototype
          criticality: low
        modules:
          core:
            - kernel/base
          agents:
            - base
        overrides:
          requiredArtifacts: []
          disabledValidations: []
      YAML
      # AGENTS.md intentionally not created

      out, err, code = run_validator("validate-agent-pack.sh", manifest_path, tmpdir)
      assert_equal 1, code, "Expected exit 1 for missing AGENTS.md. stdout: #{out}"
      assert_match(/AGENTS\.md/, err)
    end
  end

  def test_no_agent_modules_passes_vacuously
    Dir.mktmpdir do |tmpdir|
      manifest_path = File.join(tmpdir, "harness.manifest.yaml")
      File.write(manifest_path, <<~YAML)
        schemaVersion: 1
        project:
          id: test-no-agent-module
          name: No Agent Module
          maturity: prototype
          criticality: low
        modules:
          core:
            - kernel/base
        overrides:
          requiredArtifacts: []
          disabledValidations: []
      YAML

      out, err, code = run_validator("validate-agent-pack.sh", manifest_path, tmpdir)
      assert_equal 0, code, "Expected exit 0 when no agent modules declared. stderr: #{err}"
    end
  end
end

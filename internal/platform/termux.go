package platform

import (
	"os"
	"path/filepath"
	"runtime"
	"strings"
)

// IsTermux reports whether the current process is running inside a Termux environment.
func IsTermux() bool {
	if runtime.GOOS != "linux" {
		return false
	}

	if strings.TrimSpace(os.Getenv("TERMUX_VERSION")) != "" {
		return true
	}

	prefix := strings.TrimSpace(os.Getenv("PREFIX"))
	if strings.Contains(prefix, "/com.termux/") {
		return true
	}

	home := strings.TrimSpace(os.Getenv("HOME"))
	if strings.Contains(home, "/com.termux/") {
		return true
	}

	return false
}

// TermuxOpeners returns URL opener command candidates in priority order.
func TermuxOpeners() []string {
	return []string{"termux-open-url", "am"}
}

// ResolveTermuxProjectRoot returns the project root override when explicitly configured.
func ResolveTermuxProjectRoot() string {
	for _, key := range []string{"MEO2CPA_ROOT", "MEO2CPA_PROJECT_ROOT"} {
		if value, ok := os.LookupEnv(key); ok {
			trimmed := strings.TrimSpace(value)
			if trimmed != "" {
				return filepath.Clean(trimmed)
			}
		}
	}
	return ""
}

// ResolveTermuxWritablePaths returns candidate writable directories for persistent assets.
func ResolveTermuxWritablePaths() []string {
	seen := map[string]struct{}{}
	var paths []string
	appendPath := func(value string) {
		value = strings.TrimSpace(value)
		if value == "" {
			return
		}
		cleaned := filepath.Clean(value)
		if cleaned == "." {
			return
		}
		if _, ok := seen[cleaned]; ok {
			return
		}
		seen[cleaned] = struct{}{}
		paths = append(paths, cleaned)
	}

	appendPath(ResolveWritableBase())
	appendPath(ResolveTermuxProjectRoot())
	if home := strings.TrimSpace(os.Getenv("HOME")); home != "" {
		appendPath(home)
	}
	if tmp := strings.TrimSpace(os.Getenv("TMPDIR")); tmp != "" {
		appendPath(tmp)
	}
	return paths
}

// ResolveTermuxAssetDir resolves a writable asset directory under the active project root or prefix.
func ResolveTermuxAssetDir(name string) string {
	name = strings.TrimSpace(name)
	if name == "" {
		return ""
	}
	for _, base := range ResolveTermuxWritablePaths() {
		if projectRoot := ResolveTermuxProjectRoot(); projectRoot != "" && filepath.Clean(base) == projectRoot {
			return filepath.Join(base, name)
		}
	}
	for _, base := range ResolveTermuxWritablePaths() {
		return filepath.Join(base, name)
	}
	return ""
}

// TermuxRuntimeInfo returns lightweight runtime details useful for diagnostics.
func TermuxRuntimeInfo() map[string]any {
	info := map[string]any{
		"is_termux": IsTermux(),
	}

	if prefix := strings.TrimSpace(os.Getenv("PREFIX")); prefix != "" {
		info["prefix"] = prefix
	}
	if home := strings.TrimSpace(os.Getenv("HOME")); home != "" {
		info["home"] = home
	}
	if version := strings.TrimSpace(os.Getenv("TERMUX_VERSION")); version != "" {
		info["termux_version"] = version
	}
	if projectRoot := ResolveTermuxProjectRoot(); projectRoot != "" {
		info["project_root"] = projectRoot
	}
	if paths := ResolveTermuxWritablePaths(); len(paths) > 0 {
		info["writable_paths"] = paths
	}

	return info
}

// ResolveWritableBase returns a writable base directory suitable for local assets.
func ResolveWritableBase() string {
	prefix := strings.TrimSpace(os.Getenv("PREFIX"))
	if IsTermux() && prefix != "" {
		return filepath.Clean(prefix)
	}
	return ""
}

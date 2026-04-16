// Package browser provides cross-platform functionality for opening URLs in the default web browser.
// It abstracts the underlying operating system commands and provides a simple interface.
package browser

import (
	"fmt"
	"os/exec"
	"runtime"

	"github.com/router-for-me/Meo2cpa/v6/internal/platform"
	log "github.com/sirupsen/logrus"
	"github.com/skratchdot/open-golang/open"
)

// OpenURL opens the specified URL in the default web browser.
// It first attempts to use a platform-agnostic library and falls back to
// platform-specific commands if that fails.
//
// Parameters:
//   - url: The URL to open.
//
// Returns:
//   - An error if the URL cannot be opened, otherwise nil.
func OpenURL(url string) error {
	fmt.Printf("Attempting to open URL in browser: %s\n", url)

	// Try using the open-golang library first
	err := open.Run(url)
	if err == nil {
		log.Debug("Successfully opened URL using open-golang library")
		return nil
	}

	log.Debugf("open-golang failed: %v, trying platform-specific commands", err)

	// Fallback to platform-specific commands
	return openURLPlatformSpecific(url)
}

// openURLPlatformSpecific is a helper function that opens a URL using OS-specific commands.
// This serves as a fallback mechanism for OpenURL.
//
// Parameters:
//   - url: The URL to open.
//
// Returns:
//   - An error if the URL cannot be opened, otherwise nil.
func openURLPlatformSpecific(url string) error {
	cmd, errResolve := resolveOpenURLCommand(url)
	if errResolve != nil {
		return errResolve
	}

	log.Debugf("Running command: %s %v", cmd.Path, cmd.Args[1:])
	err := cmd.Start()
	if err != nil {
		return fmt.Errorf("failed to start browser command: %w", err)
	}

	log.Debug("Successfully opened URL using platform-specific command")
	return nil
}

func resolveOpenURLCommand(url string) (*exec.Cmd, error) {
	switch runtime.GOOS {
	case "darwin":
		return exec.Command("open", url), nil
	case "windows":
		return exec.Command("rundll32", "url.dll,FileProtocolHandler", url), nil
	case "linux":
		if platform.IsTermux() {
			for _, opener := range platform.TermuxOpeners() {
				switch opener {
				case "termux-open-url":
					if _, err := exec.LookPath(opener); err == nil {
						return exec.Command(opener, url), nil
					}
				case "am":
					if _, err := exec.LookPath(opener); err == nil {
						return exec.Command(opener, "start", "-a", "android.intent.action.VIEW", "-d", url), nil
					}
				}
			}
		}

		browsers := []string{"xdg-open", "x-www-browser", "www-browser", "firefox", "chromium", "google-chrome"}
		for _, browser := range browsers {
			if _, err := exec.LookPath(browser); err == nil {
				return exec.Command(browser, url), nil
			}
		}
		return nil, fmt.Errorf("no suitable browser found on Linux system")
	default:
		return nil, fmt.Errorf("unsupported operating system: %s", runtime.GOOS)
	}
}

// IsAvailable checks if the system has a command available to open a web browser.
// It verifies the presence of necessary commands for the current operating system.
//
// Returns:
//   - true if a browser can be opened, false otherwise.
func IsAvailable() bool {
	// First check if open-golang can work
	testErr := open.Run("about:blank")
	if testErr == nil {
		return true
	}

	cmd, err := resolveOpenURLCommand("about:blank")
	if err != nil {
		return false
	}
	return cmd != nil
}

// GetPlatformInfo returns a map containing details about the current platform's
// browser opening capabilities, including the OS, architecture, and available commands.
//
// Returns:
//   - A map with platform-specific browser support information.
func GetPlatformInfo() map[string]interface{} {
	info := map[string]interface{}{
		"os":        runtime.GOOS,
		"arch":      runtime.GOARCH,
		"available": IsAvailable(),
	}

	if runtime.GOOS == "linux" && platform.IsTermux() {
		for key, value := range platform.TermuxRuntimeInfo() {
			info[key] = value
		}
	}

	switch runtime.GOOS {
	case "darwin":
		info["default_command"] = "open"
	case "windows":
		info["default_command"] = "rundll32"
	case "linux":
		var availableBrowsers []string
		if platform.IsTermux() {
			for _, opener := range platform.TermuxOpeners() {
				if _, err := exec.LookPath(opener); err == nil {
					availableBrowsers = append(availableBrowsers, opener)
				}
			}
		}
		for _, browser := range []string{"xdg-open", "x-www-browser", "www-browser", "firefox", "chromium", "google-chrome"} {
			if _, err := exec.LookPath(browser); err == nil {
				availableBrowsers = append(availableBrowsers, browser)
			}
		}
		info["available_browsers"] = availableBrowsers
		if len(availableBrowsers) > 0 {
			info["default_command"] = availableBrowsers[0]
		}
	}

	return info
}

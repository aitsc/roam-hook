on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars

set targetURL to replace_chars("$0", "//", "/")

set windowIndex to 1
set tabindex to 0
set searchString to "roamresearch.com/#/app/"
set allWindowsTabURLList to ""
set allWindowsTabTitlesList to ""
set allWindowsList to ""
set windowIndex to 1
set found to false
set tabindex to 1
set windowsSearched to 0
set foundWindow to ""
set foundtab to 0
set browsername to "Google Chrome"

on goToChromePage(w, u, t)
	log "Setting url of chrome"
	using terms from application "Google Chrome"
		tell application "Google Chrome"
			activate
			if t is not -1 then
				tell w to set active tab index to t
			end if
			set index of w to 1
			if URL of active tab of w is not u then
				tell w to set URL of active tab to u
			end if
		end tell
	end using terms from
	delay 0.1
	tell application "System Events"
		tell application process "Google Chrome"
			tell window 1
				perform action "AXRaise"
			end tell
		end tell
	end tell
end goToChromePage

using terms from application "Google Chrome"
	tell application browsername
		set activeURL to URL of active tab of first window
		if ((activeURL as text) contains searchString) then
			set found to true
			set foundWindow to first window
			set foundtab to active tab of first window
			#indicate not to switch tabs
			set tabindex to -1
		end if
	end tell
end using terms from
if found is not true then
	using terms from application "Google Chrome"
		tell application browsername
			set allWindowsList to windows
			set allWindowsTabURLList to URL of tabs of every window
			set allWindowsTabTitlesList to title of tabs of every window
			set allWindowsTabs to tabs of every window
		end tell
	end using terms from
	repeat while windowIndex ≤ length of allWindowsTabURLList and windowIndex > 0
		set thisWindowsTabsURLs to item windowIndex of allWindowsTabURLList
		set thisWindowsTabsTitles to item windowIndex of allWindowsTabTitlesList
		set thisWindowsTabs to item windowIndex of allWindowsTabs
		repeat while tabindex ≤ length of thisWindowsTabsURLs and tabindex > 0
			set TabURL to item tabindex of thisWindowsTabsURLs
			if ((TabURL as text) contains searchString) then
				log "tabindex " & (tabindex as string)
				using terms from application "Google Chrome"
					tell application browsername
						set foundtab to item tabindex of thisWindowsTabs
						set foundWindow to item windowIndex of allWindowsList
					end tell
				end using terms from
				set found to true
				exit repeat
			end if
		set tabindex to tabindex + 1
		end repeat
		if found then exit repeat
		set tabindex to 1
		set windowIndex to windowIndex + 1
		if windowIndex > length of allWindowsTabURLList then
			set windowIndex to 1
		end if
		set windowsSearched to windowsSearched + 1
		if windowsSearched > length of allWindowsList then
			exit repeat
		end if
	end repeat
end if
if not found then
	display dialog "请先在 google chrome 中打开一个 roam research 网站."
end if
goToChromePage(foundWindow, targetURL, tabindex)

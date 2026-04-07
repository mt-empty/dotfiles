## Browser Automation

Use `agent-browser` for web automation and browser control.

Core workflow:
1. `agent-browser open <url>` — navigate to a page
2. `agent-browser snapshot -i` — get interactive elements with refs (@e1, @e2, ...)
3. `agent-browser click @e1` / `agent-browser fill @e2 "text"` — interact using refs
4. Re-snapshot after page changes

Install: `npm install -g agent-browser && agent-browser install`
Add skill for richer context: `npx skills add vercel-labs/agent-browser`
Run `agent-browser --help` for all commands.

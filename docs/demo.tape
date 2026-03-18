# VHS demo script — https://github.com/charmbracelet/vhs
# Run: vhs docs/demo.tape

Output docs/demo.gif

Set Theme "Catppuccin Mocha"
Set FontSize 16
Set Width 900
Set Height 500
Set Padding 20

Type "# Start the AI Sandbox"
Enter
Sleep 500ms

Type "docker-compose up -d"
Enter
Sleep 1s

Type "docker exec -it ai-sandbox bash"
Enter
Sleep 1.5s

Type "claude --version"
Enter
Sleep 1.5s

Type "claude"
Enter
Sleep 3s

Type "What can you help me with?"
Sleep 1s
Enter
Sleep 8s

# Exit
Type "/exit"
Enter
Sleep 1s

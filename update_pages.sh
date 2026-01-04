#!/bin/bash

# Script to add interactive background to all HTML files
cd "/Users/mennocoolen/Desktop/AP 25-26/Prototyping Tools/BP_HTML_09TWND-main"

# CSS to add to head
CSS='  <style>
    body {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      transition: background 0.1s ease-out;
    }
  </style>'

# JavaScript to add before closing body tag
JS='    <script>
      // Interactive background based on mouse position (X and Y axis)
      const body = document.body;
      let mouseX = 0.5;
      let mouseY = 0.5;

      document.addEventListener("mousemove", (event) => {
        // Calculate normalized mouse position (0 to 1)
        mouseX = event.clientX / window.innerWidth;
        mouseY = event.clientY / window.innerHeight;

        // X-axis controls: primary hue (0-360°) and gradient angle
        const hueX = Math.round(mouseX * 360);
        
        // Y-axis controls: secondary hue and saturation
        const hueY = Math.round(mouseY * 360);
        
        // Saturation increases from bottom to top (Y-axis inverted)
        const saturation = Math.round(50 + (1 - mouseY) * 50);
        
        // Lightness based on Y position
        const lightness = Math.round(35 + mouseY * 35);

        // Gradient angle based on X position
        const angle = mouseX * 360;

        // Apply dynamic radial gradient following mouse position
        body.style.background = `
          radial-gradient(
            circle at ${mouseX * 100}% ${mouseY * 100}%,
            hsl(${hueX}, ${saturation}%, ${lightness}%),
            hsl(${hueY}, ${saturation - 20}%, ${lightness - 15}%)
          ),
          linear-gradient(
            ${angle}deg,
            hsl(${(hueX + 120) % 360}, 60%, 40%),
            hsl(${(hueY + 180) % 360}, 60%, 50%)
          )
        `;
      });

      // Reset background on mouse leave
      document.addEventListener("mouseleave", () => {
        body.style.background = "linear-gradient(135deg, #667eea 0%, #764ba2 100%)";
      });

      // Display mouse coordinates for feedback
      const coords = document.createElement("div");
      coords.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: rgba(0, 0, 0, 0.5);
        color: white;
        padding: 10px 15px;
        border-radius: 5px;
        font-family: monospace;
        font-size: 12px;
        z-index: 9999;
        pointer-events: none;
      `;
      document.body.appendChild(coords);

      document.addEventListener("mousemove", (event) => {
        const x = Math.round(event.clientX);
        const y = Math.round(event.clientY);
        coords.textContent = `X: ${x} | Y: ${y}`;
      });
    </script>'

# Process each HTML file except week1.html (already has it)
for file in index.html week2.html week3.html week4.html week5.html week6.html week7.html week8.html week9.html week10.html; do
  if [ -f "$file" ]; then
    echo "Processing $file..."
    
    # Add CSS before </head>
    sed -i '' "/<\/head>/i\\
$CSS" "$file"
    
    # Add JavaScript before </body>
    sed -i '' "/<\/body>/i\\
$JS" "$file"
  fi
done

echo "Done!"

library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Pong in R"),
  mainPanel(
    tags$canvas(id = "pongCanvas", width = 400, height = 300),
    tags$script('
      var canvas = document.getElementById("pongCanvas");
      var ctx = canvas.getContext("2d");

      // Paddle variables
      var paddleWidth = 10;
      var paddleHeight = 60;
      var paddle1Y = canvas.height / 2 - paddleHeight / 2;
      var paddle2Y = canvas.height / 2 - paddleHeight / 2;
      var paddleSpeed = 5;

      // Ball variables
      var ballSize = 10;
      var ballX = canvas.width / 2;
      var ballY = canvas.height / 2;
      var ballSpeedX = 5;
      var ballSpeedY = 5;

      // Update function
      function update() {
        // Move paddles
        if (keys[87]) { paddle1Y -= paddleSpeed; } // W key
        if (keys[83]) { paddle1Y += paddleSpeed; } // S key
        if (keys[38]) { paddle2Y -= paddleSpeed; } // Up arrow key
        if (keys[40]) { paddle2Y += paddleSpeed; } // Down arrow key

        // Ball movement
        ballX += ballSpeedX;
        ballY += ballSpeedY;

        // Bounce off walls
        if (ballY < 0 || ballY > canvas.height) {
          ballSpeedY = -ballSpeedY;
        }

        // Bounce off paddles
        if (
          (ballX < paddleWidth && ballY > paddle1Y && ballY < paddle1Y + paddleHeight) ||
          (ballX > canvas.width - paddleWidth - ballSize && ballY > paddle2Y && ballY < paddle2Y + paddleHeight)
        ) {
          ballSpeedX = -ballSpeedX;
        }

        // Reset ball position if it goes out of bounds
        if (ballX < 0 || ballX > canvas.width) {
          ballX = canvas.width / 2;
          ballY = canvas.height / 2;
        }
      }

      // Draw function
      function draw() {
        // Clear the canvas
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        // Draw paddles
        ctx.fillStyle = "white";
        ctx.fillRect(0, paddle1Y, paddleWidth, paddleHeight);
        ctx.fillRect(canvas.width - paddleWidth, paddle2Y, paddleWidth, paddleHeight);

        // Draw ball
        ctx.beginPath();
        ctx.arc(ballX, ballY, ballSize, 0, 2 * Math.PI);
        ctx.fillStyle = "white";
        ctx.fill();
        ctx.closePath();
      }

      // Main game loop
      function gameLoop() {
        update();
        draw();
        requestAnimationFrame(gameLoop);
      }

      // Keyboard input
      var keys = {};
      window.addEventListener("keydown", function (e) {
        keys[e.keyCode] = true;
      });

      window.addEventListener("keyup", function (e) {
        keys[e.keyCode] = false;
      });

      // Start the game loop
      gameLoop();
    ')
  )
)

# Run the application
shinyApp(ui, server = function(input, output) {})

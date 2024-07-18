let score = 0;
let timeLeft = 10;
let gameStarted = false;
const timerElement = document.getElementById("timer");
const scoreElement = document.getElementById("score");
const topScoresElement = document.getElementById("top-scores");
const playerNameInput = document.getElementById("name");

function incrementScore() {
  if (gameStarted && timeLeft > 0) {
    score += 1;
    scoreElement.textContent = `Score: ${score}`;
  }
}

function startTimer() {
  const timer = setInterval(() => {
    if (timeLeft > 0) {
      timeLeft -= 1;
      timerElement.textContent = `Time: ${timeLeft}`;
    } else {
      clearInterval(timer);
      //   alert(`Time's up! Your score is ${score}`);
      submitScore(playerNameInput.value.trim());
    }
  }, 1000);
}

function startGame() {
  const playerName = playerNameInput.value.trim();
  if (!playerName) {
    alert("Please enter your name before starting the game.");
    return;
  }
  if (!gameStarted) {
    gameStarted = true;
    startTimer();
  }
  incrementScore();
}
async function submitScore(playerName) {
  const response = await fetch("http://172.18.0.2:5000/scores", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ player_name: playerName, score: score }),
  });
  if (response.ok) {
    const scoresResponse = await fetch("http://172.18.0.2:5000/scores");
    const scores = await scoresResponse.json();
    displayScores(scores);
    resetGame();
  } else {
    const error = await response.json();
    alert(`Error: ${error.error}`);
  }
}

function displayScores(scores) {
  topScoresElement.innerHTML = "<h2>Top Scores</h2>";
  const scoresList = document.createElement("ul");
  scores.forEach((score) => {
    const li = document.createElement("li");
    li.textContent = `Player: ${score[0]} - Score: ${score[1]}`;
    scoresList.appendChild(li);
  });
  topScoresElement.appendChild(scoresList);
}

function resetGame() {
  score = 0;
  timeLeft = 10;
  gameStarted = false;
  scoreElement.textContent = "Score: 0";
  timerElement.textContent = "Time: 10";
  playerNameInput.value = "";
}

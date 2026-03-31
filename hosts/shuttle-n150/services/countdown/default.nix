{ pkgs, ... }:
let
  countdownHtml = pkgs.writeText "index.html" ''
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Presentation Timer</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                background: #0a0a0a;
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                color: white;
            }

            .container {
                text-align: center;
                width: 100%;
                max-width: 900px;
                padding: 40px;
            }

            .countdown-display {
                font-size: clamp(8rem, 25vw, 16rem);
                font-weight: 200;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                letter-spacing: 0.05em;
                color: #ffffff;
                margin: 60px 0;
                transition: color 0.3s ease;
            }

            .countdown-display.warning {
                color: #f59e0b;
            }

            .countdown-display.danger {
                color: #ef4444;
                animation: pulse 1s infinite;
            }

            .countdown-display.finished {
                color: #ef4444;
                animation: pulse 0.5s infinite;
            }

            @keyframes pulse {

                0%,
                100% {
                    opacity: 1;
                }

                50% {
                    opacity: 0.5;
                }
            }

            .controls {
                display: flex;
                gap: 16px;
                justify-content: center;
                align-items: center;
                flex-wrap: wrap;
            }

            button {
                padding: 16px 32px;
                font-size: 1rem;
                font-weight: 500;
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.2s ease;
                background: transparent;
                color: white;
                letter-spacing: 0.05em;
                text-transform: uppercase;
            }

            button:hover {
                background: rgba(255, 255, 255, 0.1);
                border-color: rgba(255, 255, 255, 0.4);
            }

            button:active {
                background: rgba(255, 255, 255, 0.15);
            }

            .btn-primary {
                background: white;
                color: #0a0a0a;
                border-color: white;
            }

            .btn-primary:hover {
                background: #e5e5e5;
                border-color: #e5e5e5;
            }

            .btn-stop {
                border-color: rgba(239, 68, 68, 0.5);
                color: #ef4444;
            }

            .btn-stop:hover {
                background: rgba(239, 68, 68, 0.1);
                border-color: #ef4444;
            }

            .divider {
                width: 1px;
                height: 24px;
                background: rgba(255, 255, 255, 0.2);
                margin: 0 8px;
            }

            .custom-group {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            input[type="number"] {
                padding: 16px;
                font-size: 1rem;
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 6px;
                width: 80px;
                text-align: center;
                background: transparent;
                color: white;
                font-weight: 500;
                -moz-appearance: textfield;
            }

            input[type="number"]::-webkit-outer-spin-button,
            input[type="number"]::-webkit-inner-spin-button {
                -webkit-appearance: none;
                margin: 0;
            }

            input[type="number"]:focus {
                outline: none;
                border-color: rgba(255, 255, 255, 0.5);
            }

            input[type="number"]::placeholder {
                color: rgba(255, 255, 255, 0.4);
            }

            .label {
                font-size: 0.85rem;
                color: rgba(255, 255, 255, 0.5);
                text-transform: uppercase;
                letter-spacing: 0.1em;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <div class="countdown-display" id="display">00:00</div>

            <div class="controls">
                <button class="btn-primary" onclick="startCountdown(15)">15 min</button>
                <button class="btn-primary" onclick="startCountdown(5)">5 min</button>

                <div class="divider"></div>

                <div class="custom-group">
                    <input type="number" id="customMinutes" min="1" max="999" placeholder="—">
                    <span class="label">min</span>
                    <button onclick="startCustomCountdown()">Start</button>
                </div>

                <div class="divider"></div>

                <button class="btn-stop" onclick="stopCountdown()">Stop</button>
            </div>
        </div>

        <script>
            let countdownInterval = null;
            let remainingSeconds = 0;
            let audioContext = null;

            function playAlarm() {
                if (!audioContext) {
                    audioContext = new (window.AudioContext || window.webkitAudioContext)();
                }

                const duration = 0.3;
                const frequency = 880;
                const beeps = 5;

                for (let i = 0; i < beeps; i++) {
                    setTimeout(() => {
                        const oscillator = audioContext.createOscillator();
                        const gainNode = audioContext.createGain();

                        oscillator.connect(gainNode);
                        gainNode.connect(audioContext.destination);

                        oscillator.frequency.value = frequency;
                        oscillator.type = 'sine';

                        gainNode.gain.setValueAtTime(0.4, audioContext.currentTime);
                        gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + duration);

                        oscillator.start(audioContext.currentTime);
                        oscillator.stop(audioContext.currentTime + duration);
                    }, i * 350);
                }
            }

            function formatTime(seconds) {
                const mins = Math.floor(seconds / 60);
                const secs = seconds % 60;
                return `${"$"}{mins.toString().padStart(2, '0')}:${"$"}{secs.toString().padStart(2, '0')}`;
            }

            function updateDisplay() {
                const display = document.getElementById('display');
                display.textContent = formatTime(remainingSeconds);

                display.classList.remove('warning', 'danger', 'finished');

                if (remainingSeconds === 0 && countdownInterval === null) {
                    display.classList.add('finished');
                } else if (remainingSeconds <= 10 && remainingSeconds > 0) {
                    display.classList.add('danger');
                } else if (remainingSeconds <= 60 && remainingSeconds > 0) {
                    display.classList.add('warning');
                }
            }

            function startCountdown(minutes) {
                if (countdownInterval) {
                    clearInterval(countdownInterval);
                }

                remainingSeconds = minutes * 60;
                updateDisplay();

                countdownInterval = setInterval(() => {
                    remainingSeconds--;
                    updateDisplay();

                    if (remainingSeconds <= 0) {
                        clearInterval(countdownInterval);
                        countdownInterval = null;
                        updateDisplay();
                        playAlarm();
                    }
                }, 1000);
            }

            function startCustomCountdown() {
                const input = document.getElementById('customMinutes');
                const minutes = parseInt(input.value);

                if (isNaN(minutes) || minutes < 1) {
                    return;
                }

                startCountdown(minutes);
                input.value = "";
            }

            function stopCountdown() {
                if (countdownInterval) {
                    clearInterval(countdownInterval);
                    countdownInterval = null;
                }
                remainingSeconds = 0;
                const display = document.getElementById('display');
                display.textContent = '00:00';
                display.classList.remove('warning', 'danger', 'finished');
            }

            document.getElementById('customMinutes').addEventListener('keypress', (e) => {
                if (e.key === 'Enter') {
                    startCustomCountdown();
                }
            });
        </script>
    </body>

    </html>
  '';
in
{
  systemd.tmpfiles.rules = [
    "d /var/lib/countdown 0755 root root -"
    "L+ /var/lib/countdown/index.html - - - - ${countdownHtml}"
  ];
}

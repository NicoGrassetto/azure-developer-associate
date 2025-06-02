// Handles the counter increment logic

document.addEventListener('DOMContentLoaded', function() {
    const counterDisplay = document.getElementById('counter');
    const incrementBtn = document.getElementById('increment-btn');
    let count = 0;

    incrementBtn.addEventListener('click', function() {
        count++;
        counterDisplay.textContent = count;
    });
});

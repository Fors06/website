// Открытие модального окна
function openModal() {
    document.getElementById("modal").style.display = "block";
}

// Закрытие модального окна
function closeModal() {
    document.getElementById("modal").style.display = "none";
}

// Закрыть окно при клике вне формы
window.onclick = function(event) {
    if (event.target === document.getElementById("modal")) {
        closeModal();
    }
};
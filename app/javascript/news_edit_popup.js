console.log('news_edit_popup.jsを読み込みました')
document.addEventListener('DOMContentLoaded', () => {
  const editButtons = document.querySelectorAll('.edit-link');
  const overlay = document.querySelector('.overlay');
  const popup = document.querySelector('.edit-form-popup');

  editButtons.forEach(button => {
    button.addEventListener('click', (event) => {
      event.preventDefault();
      const url = button.getAttribute('href');
      fetch(url, {
        headers: {
          'X-Requested-With': 'XMLHttpRequest'
        }
      })
      .then(response => response.text())
      .then(data => {
        popup.innerHTML = data;
        overlay.style.display = 'block';
        popup.style.display = 'block';
      });
    });
  });

  overlay.addEventListener('click', () => {
    overlay.style.display = 'none';
    popup.style.display = 'none';
  });
});

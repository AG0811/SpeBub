console.log('news_edit_popup.jsを読み込みました')
document.addEventListener("turbolinks:load", function() {
  document.querySelectorAll('.edit-link').forEach(function(link) {
    link.addEventListener('click', function(event) {
      event.preventDefault();
      const url = this.getAttribute('href');

      fetch(url)
        .then(response => response.text())
        .then(html => {
          document.querySelector('.form-popup').innerHTML = html;
          document.querySelector('.overlay').style.display = 'block';
          document.querySelector('.form-popup').style.display = 'block';
        })
        .catch(error => console.log(error));
    });
  });

  // Close the popup when clicking the overlay
  document.querySelector('.overlay').addEventListener('click', function() {
    document.querySelector('.overlay').style.display = 'none';
    document.querySelector('.form-popup').style.display = 'none';
  });
});

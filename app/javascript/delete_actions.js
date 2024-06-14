document.addEventListener('turbo:load', function() {
    // 削除ボタンのイベントをキャプチャし、ログを表示してからイベントの伝播を停止
  // const deleteForms = document.querySelectorAll('form.button_to');
  // deleteForms.forEach(form => {
  //   const confirmMessage = "注：記事を消去しますか？";
  //   form.addEventListener('submit', (event) => {
  //     if (!confirm(confirmMessage)) {
  //       event.stopPropagation();
  //       event.preventDefault();
  //     }
  //   });
  // });
  const deleteButtons = document.querySelectorAll('form.button_to button');
  deleteButtons.forEach(button => {
    button.addEventListener('click', (event) => {
      event.stopPropagation();
      const confirmMessage = "注：記事を消去しますか？";
      if (!confirm(confirmMessage)) {
        event.preventDefault();
      }
    });
  });
});
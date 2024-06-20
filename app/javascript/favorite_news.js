// document.addEventListener('DOMContentLoaded', () => {
//   const favoriteButtons = document.querySelectorAll('.favorite-button');

//   favoriteButtons.forEach(button => {
//     button.addEventListener('ajax:success', (event) => {
//       const [data, status, xhr] = event.detail;
//       if (data.success) {
//         if (data.action === 'create') {
//           button.innerText = 'お気に入りから削除';
//           button.setAttribute('data-method', 'delete');
//         } else if (data.action === 'destroy') {
//           button.innerText = 'お気に入りに追加';
//           button.setAttribute('data-method', 'post');
//         }
//       }
//     });

//     button.addEventListener('ajax:error', (event) => {
//       alert('お気に入り操作に失敗しました');
//     });
//   });
// });

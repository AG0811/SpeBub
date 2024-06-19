document.addEventListener('turbo:load', () => {
  const userDataDiv = document.getElementById('user-data');

  if (!userDataDiv) {
    console.error('#user-data element not found');
    return;
  }
  const userId = userDataDiv.dataset.userId; // ユーザーIDを取得

  const menuItems = document.querySelectorAll('.menu .item');
  const selectElement = document.getElementById('prefecture-select');
  const defaultItem = document.querySelector('.menu .item[data-filter="all"]');
  const newsItems = document.querySelectorAll('.news-item');
  let userAddressId = selectElement.value; // 初期の都道府県の値を取得

  // すべてのメニューアイテムから背景色を削除する関数
  const resetBackgroundColors = () => {
    menuItems.forEach(item => {
      item.style.backgroundColor = '';
    });
  };

  // メニューアイテムクリックを処理する関数
  const handleMenuItemClick = (event) => {
    resetBackgroundColors();
    const clickedItem = event.target;
    clickedItem.style.backgroundColor = '#ff9800'; // クリックされたアイテムの背景色を変更

    if (clickedItem.dataset.filter === 'search') {
      selectElement.classList.remove('hidden');
      const selectedPrefectureId = selectElement.value;
      filterNewsItems('search', selectedPrefectureId);
    } else if (clickedItem.dataset.filter === 'mine') {
      filterNewsItems('mine', userId); // userIdを渡してフィルタリング
    } else {
      selectElement.classList.add('hidden');
      filterNewsItems(clickedItem.dataset.filter);
    }
  };

  // ニュースアイテムをフィルタリングする関数
  const filterNewsItems = (filter, selectedPrefectureId = null) => {
    newsItems.forEach(item => {
      const userItemId = item.dataset.userId; // ニュースアイテムのユーザーIDを取得
      const prefectureId = item.dataset.prefectureId;
      const categoryId = item.dataset.categoryId;

      if (filter === 'all') {
        item.style.display = prefectureId === userAddressId ? 'block' : 'none';
      } else if (filter === 'favorite') {
        // お気に入りのフィルタリングロジックを実装する（必要に応じて）
        item.style.display = 'none'; // 例：今はすべてのアイテムを非表示にする
      } else if (filter === 'unread') {
        // 未読のフィルタリングロジックを実装する（必要に応じて）
        item.style.display = 'none'; // 例：今はすべてのアイテムを非表示にする
      } else if (filter === 'search') {
        if (prefectureId === selectedPrefectureId) {
          item.style.display = 'block';
        } else {
          item.style.display = 'none';
        }
      } else if (filter === 'mine') {
        item.style.display = userItemId === userId ? 'block' : 'none'; // ユーザーの投稿記事のみ表示
      }
    });
  };

  // すべてのメニューアイテムにクリックイベントリスナーを追加する
  menuItems.forEach(item => {
    item.addEventListener('click', handleMenuItemClick);
  });

  // デフォルトの選択されたアイテムを設定する
  if (defaultItem) {
    defaultItem.style.backgroundColor = '#ff9800'; // 初期表示の背景色を設定
    filterNewsItems(defaultItem.dataset.filter); // 初期フィルタリング
  }

  // 最初はセレクト要素を非表示にする
  selectElement.classList.add('hidden');

  // セレクト要素に変更イベントリスナーを追加する
  selectElement.addEventListener('change', (event) => {
    userAddressId = event.target.value; // セレクトボックスの値を更新
    filterNewsItems('search', userAddressId);
  });
});

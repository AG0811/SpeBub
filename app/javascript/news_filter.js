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
  const dateSeparators = document.querySelectorAll('.news-date-separator');
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
      selectElement.classList.add('hidden');
      filterNewsItems('mine', userId); // userIdを渡してフィルタリング
    } else {
      selectElement.classList.add('hidden');
      filterNewsItems(clickedItem.dataset.filter);
    }
  };

  // ニュースアイテムをフィルタリングする関数
  const filterNewsItems = (filter, selectedPrefectureId = null) => {
    const displayedDates = new Set();

    newsItems.forEach(item => {
      const userItemId = item.dataset.userId; // ニュースアイテムのユーザーIDを取得
      const prefectureId = item.dataset.prefectureId;
      const categoryId = item.dataset.categoryId;
<<<<<<< Updated upstream
      const newsDate = item.dataset.date;

      let shouldDisplay = false;
      if (filter === 'all') {
        shouldDisplay = prefectureId === userAddressId;
=======
  
      if (filter === 'all') {
        item.style.display = prefectureId === userAddressId ? 'block' : 'none';// すべてのニュースアイテムを表示する
>>>>>>> Stashed changes
      } else if (filter === 'favorite') {
        // お気に入りのフィルタリングロジックを実装する（必要に応じて）
      } else if (filter === 'unread') {
        // 未読のフィルタリングロジックを実装する（必要に応じて）
      } else if (filter === 'search') {
        shouldDisplay = prefectureId === selectedPrefectureId;
      } else if (filter === 'mine') {
        shouldDisplay = userItemId === userId; // ユーザーの投稿記事のみ表示
      }

      item.style.display = shouldDisplay ? 'block' : 'none';
      if (shouldDisplay) {
        displayedDates.add(newsDate);
      }
    });

    // 日付の区切りを表示/非表示にする
    dateSeparators.forEach(separator => {
      const separatorDate = separator.dataset.date;
      separator.style.display = displayedDates.has(separatorDate) ? 'block' : 'none';
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

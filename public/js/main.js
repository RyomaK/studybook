function check(){
	var flag = 0;
	if(document.score.test.value == ""){ // 「テスト種類」の入力をチェック
		flag = 1;
	}
	else if(document.score.semester.value == ""){ // 「国語」の入力をチェック
		flag = 1;
	}
	else if(document.score.japanese.value == ""){ // 「国語」の入力をチェック
		flag = 1;
	}
	else if(document.score.math.value == ""){ // 「数学」の入力をチェック
		flag = 1;
	}
	else if(document.score.english.value == ""){ // 「英語」の入力をチェック
		flag = 1;
	}
	else if(document.score.science.value == ""){ // 「理科」の入力をチェック
		flag = 1;
	}
	else if(document.score.social.value == ""){ // 「社会」の入力をチェック
		flag = 1;
	}
	// 設定終了
	if(flag){
		window.alert('必須項目に未入力がありました'); // 入力漏れがあれば警告ダイアログを表示
		return false; // 送信を中止
	}
	else{
		return true; // 送信を実行
	}

}

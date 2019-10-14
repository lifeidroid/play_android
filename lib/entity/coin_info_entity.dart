class CoinInfoEntity {
	int rank;
	int userId;
	int coinCount;
	String username;

	CoinInfoEntity({this.rank, this.userId, this.coinCount, this.username});

	CoinInfoEntity.fromJson(Map<String, dynamic> json) {
		rank = json['rank'];
		userId = json['userId'];
		coinCount = json['coinCount'];
		username = json['username'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['rank'] = this.rank;
		data['userId'] = this.userId;
		data['coinCount'] = this.coinCount;
		data['username'] = this.username;
		return data;
	}
}

class CollectEntity {
	int publishTime;
	int visible;
	String niceDate;
	String author;
	int zan;
	String origin;
	String chapterName;
	String link;
	String title;
	int userId;
	int originId;
	String envelopePic;
	int chapterId;
	int id;
	int courseId;
	String desc;

	CollectEntity({this.publishTime, this.visible, this.niceDate, this.author, this.zan, this.origin, this.chapterName, this.link, this.title, this.userId, this.originId, this.envelopePic, this.chapterId, this.id, this.courseId, this.desc});

	CollectEntity.fromJson(Map<String, dynamic> json) {
		publishTime = json['publishTime'];
		visible = json['visible'];
		niceDate = json['niceDate'];
		author = json['author'];
		zan = json['zan'];
		origin = json['origin'];
		chapterName = json['chapterName'];
		link = json['link'];
		title = json['title'];
		userId = json['userId'];
		originId = json['originId'];
		envelopePic = json['envelopePic'];
		chapterId = json['chapterId'];
		id = json['id'];
		courseId = json['courseId'];
		desc = json['desc'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['publishTime'] = this.publishTime;
		data['visible'] = this.visible;
		data['niceDate'] = this.niceDate;
		data['author'] = this.author;
		data['zan'] = this.zan;
		data['origin'] = this.origin;
		data['chapterName'] = this.chapterName;
		data['link'] = this.link;
		data['title'] = this.title;
		data['userId'] = this.userId;
		data['originId'] = this.originId;
		data['envelopePic'] = this.envelopePic;
		data['chapterId'] = this.chapterId;
		data['id'] = this.id;
		data['courseId'] = this.courseId;
		data['desc'] = this.desc;
		return data;
	}
}

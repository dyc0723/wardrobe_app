enum Gender { male, female, other }

enum Occasion {
  casual('休闲', '日常出门、朋友聚会'),
  work('通勤', '上班、上学'),
  formal('正式', '会议、晚宴、典礼'),
  date('约会', '约会、烛光晚餐'),
  sport('运动', '健身、跑步、户外活动'),
  home('居家', '在家休息');

  final String label;
  final String description;
  const Occasion(this.label, this.description);
}

enum Season {
  spring('春', 3, 5),
  summer('夏', 6, 8),
  autumn('秋', 9, 11),
  winter('冬', 12, 2);

  final String label;
  final int startMonth;
  final int endMonth;
  const Season(this.label, this.startMonth, this.endMonth);

  static Season fromMonth(int month) {
    return Season.values.firstWhere(
      (s) => month >= s.startMonth && month <= s.endMonth,
      orElse: () => Season.spring,
    );
  }
}

enum Style {
  minimalist('简约', '干净利落的纯色基础款'),
  street('街头潮流', '卫衣、潮牌、运动鞋'),
  business('商务', '西装、衬衫、皮鞋'),
  sweetCool('甜酷', '甜中带酷的混搭'),
  retro('复古', '古着、格纹、高腰'),
  mixAndMatch('混搭', '不设限，自由组合');

  final String label;
  final String description;
  const Style(this.label, this.description);
}

enum Category {
  top('上衣'),
  bottom('下装'),
  dress('连衣裙'),
  jacket('外套'),
  shoes('鞋'),
  bag('包'),
  accessory('配饰');

  final String label;
  const Category(this.label);
}

enum ClothingColor {
  white('白色', '#FFFFFF'),
  black('黑色', '#000000'),
  gray('灰色', '#808080'),
  beige('米色', '#F5F5DC'),
  navy('藏青', '#000080'),
  blue('蓝色', '#0000FF'),
  lightBlue('浅蓝', '#87CEEB'),
  red('红色', '#FF0000'),
  pink('粉色', '#FFC0CB'),
  green('绿色', '#008000'),
  olive('橄榄绿', '#556B2F'),
  yellow('黄色', '#FFFF00'),
  orange('橙色', '#FFA500'),
  purple('紫色', '#800080'),
  brown('棕色', '#A52A2A'),
  khaki('卡其', '#C3B091'),
  denim('牛仔', '#1565C0'),
  print_('印花', 'multi'),
  stripe('条纹', 'stripe'),
  plaid('格纹', 'plaid');

  final String label;
  final String hex;
  const ClothingColor(this.label, this.hex);
}

enum MaterialType {
  cotton('棉'),
  linen('亚麻'),
  wool('羊毛'),
  silk('丝绸'),
  denim('牛仔'),
  leather('皮革'),
  polyester('聚酯纤维'),
  other('其他');

  final String label;
  const MaterialType(this.label);
}

enum Thickness {
  veryThin('超薄', 1),
  thin('薄', 2),
  medium('适中', 3),
  thick('厚', 4),
  veryThick('加厚', 5);

  final String label;
  final int value;
  const Thickness(this.label, this.value);
}

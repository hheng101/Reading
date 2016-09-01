//
//  ReadingVC.m
//  JYReading
//
//  Created by 俞洋 on 16/9/1.
//  Copyright © 2016年 Journey. All rights reserved.
//

#import "ReadingVC.h"
#import "E_Paging.h"
#import "JYShotNavigationController.h"
@interface ReadingVC ()<UIScrollViewDelegate,JYShotBackProtocol>

@property(nonatomic,strong)UIScrollView *MainScroller;
//分页的字符串
@property(nonatomic,strong)NSMutableArray *textArray;
//复用池
@property(nonatomic,strong)NSMutableArray *LabelsArray;

@property(nonatomic,assign)CGFloat lastX;

@property(nonatomic,assign)NSInteger totalPage;

@property(nonatomic,assign)NSInteger currentPage;

@property(nonatomic,strong)NSMutableArray *rangeOfPages;

@property(nonatomic,strong)E_Paging *pageManager;
@end

@implementation ReadingVC

-(BOOL)enablePanBack:(JYShotNavigationController *)NavigationController
{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textArray = [NSMutableArray array];
    NSString *str = @"两天时间说快不快说慢不慢，眨眼间就过去了。 此时还正在凌晨不过魂界内因为族内比赛的这件事都变得热闹非凡。在报名台前，来报名参加比赛的人也是排起了长龙，一个个雄心壮志。但人数实在是太过庞大，于是长老会不得不商议决定，只有15岁以下，天命一阶以上的人才能参加比赛，这规定一出顿时就刷下了许多人，可人数依旧众多。这时离正式的比赛时间只有八个小时，所有幕后台前的工作都在紧锣密鼓的进行着，这时的魂蚀咗也在自己修炼的密室中缓缓睁开双目，顺势吐出一口浊气，站起来伸了个懒腰“呼，坐了整整两天两夜，腰酸背痛的”与此同时他斜眼看了看窗外“咦，快要开赛了，出去逛逛再去比赛场应该时间刚刚好吧。”密室厚重的石门缓缓开启。这石门可以屏蔽各种声音打扰为修炼者提供一个良好的修炼条件，不然在深度修炼状态的被毫无防备的干扰是有可能走火入魔的，这些常识问题魂少可是做的很好的，不过代价也是相当大的，拿钱的数字就不是一般人所能承受的。所谓的深度修炼就是处于感悟天地规则和顿悟的时候，不然平时的吸取天地灵气只能算是浅度修炼，浅度修炼被意外打扰并没有什么大问题。当石门打开，走出石门眼前便是一座恢弘的的城池，一眼望不到边。魂蚀咗的居住地可是魂界的高山上，不仅灵气相对更加浓厚风景也是数一数二的，当然也只有族长的子女才有这等的修炼条件。石门缓缓开启后又逐渐关闭，魂少御气而行，双脚离地如一道风一般向山下行去。到了天命这个等级就可以用自身的内力把自身托离地面少许，即使是少许也足矣增加行进速度了，不过刚刚到达天命级别的人只能勉强使用，只有实力越高才能用得更加熟练，现在魂少处于天命三阶中期，也可以进行熟练的操作了，一切都是建立在实力之上。刚一下山，就吸引了大批众人的目光，“咦！那不是魂蚀咗，魂少吗？”“是啊是啊，好帅”顿时就引来一群“无知少女”的围观，甚至于还有人来要签名的，魂蚀咗看她们如此热情自己那小小的虚荣心瞬间就升腾起来了，毫不犹豫的就答应了。众女一瞧，“我也要！”“给我签一个！”“魂少，这里这里！”就因为他这个小小的举动引起了大家的骚动，面前的路已经完全被阻挡，魂蚀咗此时的心情十分苦闷啊，在这里又不敢随意使用内力，容易伤及无辜呀。于是乎，不可一世的魂少主被一群少女追得抱头鼠窜，狼狈不堪，这时修炼人的敏捷和耐力就体现出来了，虽然路途艰苦可好歹跑出来了呀，不得已他只得将自己的面容改变.本来一脸英气的脸，变得萌萌哒，一双大大水汪汪的眼睛扑闪扑闪的，还略带一点婴儿肥，修长的身材也稍稍变矮了一些，“这下可没人认得出我了吧！”那人畜无害的脸上露出一种得意的笑容。嘿，不巧的是这一幕被恰好出关的魂诗羽给瞧见了，她叫一个乐啊，这小子谁叫你平时装帅装酷的，这下知道厉害了吧。乐归乐，望望天色也不早了，该前往比赛场了，小子努力吧！随即便以天命五阶初期的实力双脚离地腾空而起，化为一道飓风般的速度向着比赛场的位置离去，那速度比魂蚀咗都还要快上不少，不然比魂蚀咗高出的两阶是吃素的啊！这时的魂易天还在报名的长龙里，这时离开始比赛还有1个小时，但好在魂易天前面没几人了，用不了几分钟就可以报名参加比赛了。说巧不巧，魂蚀咗就在此时从一个豪华通道直接进入会场，魂易天十分鄙夷，凭什么我们就得排队，凭什么我们就得等这么久，凭什么他就能直接进入会场，就因为他的地位比我们高，就因为他是族长的儿子！！！哼，魂蚀咗，你等着，我会将你打败，我要向世人证明，就算是出身平凡依旧可以璀璨夺目。魂易天的内心虽然正在惊涛骇浪，但毫无面部表情，依旧是一副平淡无奇的样子。填完报名表的魂易天也缓步走进比赛场但他还是下意识的向vip通道看去。此时的魂诗羽也到了，看见了魂易天正望向这一边，出于礼貌魂诗羽对他淡淡一笑，可他依旧是一副波澜不惊的样子转身离去。这引得魂诗羽撇了撇眉，这小子看着挺不简单的啊，看来这次大会有的一拼了。然后也转身进入比赛场。魂族的比赛场呈椭圆形犹如一个巨大的太阳，金碧辉煌。比赛场内，可以容纳三十多万人的位置此时也是座无虚席，在观众席的中的一般都是未修练的普通人或等级比较低的人。在观众席中央便是比赛场地，由坚硬的花岗岩石铺成，同时还有族长亲自施下的符文用于进一步加固比赛场地。一道金光闪耀，比赛场中央升起一道金柱，当光芒散去后，大众才看清金柱的正面目，一条条巨龙盘旋于上，苍劲的身躯，直冲上青天，青天之中有一颗光彩夺目的龙珠，互相争夺，活灵活现犹如有生命一般，并且整个黄金柱还在不断的吞吐天地灵气，发出瑞光。族长则屹立在黄金柱上身穿一件纯黑色的战斗长袍，一张略带沧桑的英俊脸，双手负背，一种浓浓的威压向着场地四周扩散开来，不可一世，立于天地之间，不败风范，这就是族长。“大家肃静！！”一道响亮的声音突然在大众的耳边炸响，随即硕大的比赛场中转瞬安静，这就是族长的威信，“今天是一个展现自身实力的时刻，在距上一届比赛五年后，第二届古界资格比赛再一次开启，这一次我不想再多说什么。”一种雄厚的声音再一次在耳边响起，接至而来的更使大家热血沸腾“我只想告诉各位，这一次年轻天才汇聚，这是一次无与伦比的比赛，这是展现你们热血，志向，实力的一刻，希望你们不要留下遗憾，在这一次的比赛之后我会收一个关门弟子，希望你们能在这次比赛中大放光彩！”话音一落，赛场上顿时射血沸腾，谁不想成为族长弟子，谁不想一气冲天。就在这嘈杂时刻族长用一个更为洪亮的声音宣布“比赛开始”，随即在赛场顶端悬挂的古朴道钟莫名响起，这钟声厚重圆润，仿佛能安抚众人激动的心情，这也正式宣布比赛开始！！！两天时间说快不快说慢不慢，眨眼间就过去了。 此时还正在凌晨不过魂界内因为族内比赛的这件事都变得热闹非凡。在报名台前，来报名参加比赛的人也是排起了长龙，一个个雄心壮志。但人数实在是太过庞大，于是长老会不得不商议决定，只有15岁以下，天命一阶以上的人才能参加比赛，这规定一出顿时就刷下了许多人，可人数依旧众多。这时离正式的比赛时间只有八个小时，所有幕后台前的工作都在紧锣密鼓的进行着，这时的魂蚀咗也在自己修炼的密室中缓缓睁开双目，顺势吐出一口浊气，站起来伸了个懒腰“呼，坐了整整两天两夜，腰酸背痛的”与此同时他斜眼看了看窗外“咦，快要开赛了，出去逛逛再去比赛场应该时间刚刚好吧。”密室厚重的石门缓缓开启。这石门可以屏蔽各种声音打扰为修炼者提供一个良好的修炼条件，不然在深度修炼状态的被毫无防备的干扰是有可能走火入魔的，这些常识问题魂少可是做的很好的，不过代价也是相当大的，拿钱的数字就不是一般人所能承受的。所谓的深度修炼就是处于感悟天地规则和顿悟的时候，不然平时的吸取天地灵气只能算是浅度修炼，浅度修炼被意外打扰并没有什么大问题。当石门打开，走出石门眼前便是一座恢弘的的城池，一眼望不到边。魂蚀咗的居住地可是魂界的高山上，不仅灵气相对更加浓厚风景也是数一数二的，当然也只有族长的子女才有这等的修炼条件。石门缓缓开启后又逐渐关闭，魂少御气而行，双脚离地如一道风一般向山下行去。到了天命这个等级就可以用自身的内力把自身托离地面少许，即使是少许也足矣增加行进速度了，不过刚刚到达天命级别的人只能勉强使用，只有实力越高才能用得更加熟练，现在魂少处于天命三阶中期，也可以进行熟练的操作了，一切都是建立在实力之上。刚一下山，就吸引了大批众人的目光，“咦！那不是魂蚀咗，魂少吗？”“是啊是啊，好帅”顿时就引来一群“无知少女”的围观，甚至于还有人来要签名的，魂蚀咗看她们如此热情自己那小小的虚荣心瞬间就升腾起来了，毫不犹豫的就答应了。众女一瞧，“我也要！”“给我签一个！”“魂少，这里这里！”就因为他这个小小的举动引起了大家的骚动，面前的路已经完全被阻挡，魂蚀咗此时的心情十分苦闷啊，在这里又不敢随意使用内力，容易伤及无辜呀。于是乎，不可一世的魂少主被一群少女追得抱头鼠窜，狼狈不堪，这时修炼人的敏捷和耐力就体现出来了，虽然路途艰苦可好歹跑出来了呀，不得已他只得将自己的面容改变.本来一脸英气的脸，变得萌萌哒，一双大大水汪汪的眼睛扑闪扑闪的，还略带一点婴儿肥，修长的身材也稍稍变矮了一些，“这下可没人认得出我了吧！”那人畜无害的脸上露出一种得意的笑容。嘿，不巧的是这一幕被恰好出关的魂诗羽给瞧见了，她叫一个乐啊，这小子谁叫你平时装帅装酷的，这下知道厉害了吧。乐归乐，望望天色也不早了，该前往比赛场了，小子努力吧！随即便以天命五阶初期的实力双脚离地腾空而起，化为一道飓风般的速度向着比赛场的位置离去，那速度比魂蚀咗都还要快上不少，不然比魂蚀咗高出的两阶是吃素的啊！这时的魂易天还在报名的长龙里，这时离开始比赛还有1个小时，但好在魂易天前面没几人了，用不了几分钟就可以报名参加比赛了。说巧不巧，魂蚀咗就在此时从一个豪华通道直接进入会场，魂易天十分鄙夷，凭什么我们就得排队，凭什么我们就得等这么久，凭什么他就能直接进入会场，就因为他的地位比我们高，就因为他是族长的儿子！！！哼，魂蚀咗，你等着，我会将你打败，我要向世人证明，就算是出身平凡依旧可以璀璨夺目。魂易天的内心虽然正在惊涛骇浪，但毫无面部表情，依旧是一副平淡无奇的样子。填完报名表的魂易天也缓步走进比赛场但他还是下意识的向vip通道看去。此时的魂诗羽也到了，看见了魂易天正望向这一边，出于礼貌魂诗羽对他淡淡一笑，可他依旧是一副波澜不惊的样子转身离去。这引得魂诗羽撇了撇眉，这小子看着挺不简单的啊，看来这次大会有的一拼了。然后也转身进入比赛场。魂族的比赛场呈椭圆形犹如一个巨大的太阳，金碧辉煌。比赛场内，可以容纳三十多万人的位置此时也是座无虚席，在观众席的中的一般都是未修练的普通人或等级比较低的人。在观众席中央便是比赛场地，由坚硬的花岗岩石铺成，同时还有族长亲自施下的符文用于进一步加固比赛场地。一道金光闪耀，比赛场中央升起一道金柱，当光芒散去后，大众才看清金柱的正面目，一条条巨龙盘旋于上，苍劲的身躯，直冲上青天，青天之中有一颗光彩夺目的龙珠，互相争夺，活灵活现犹如有生命一般，并且整个黄金柱还在不断的吞吐天地灵气，发出瑞光。族长则屹立在黄金柱上身穿一件纯黑色的战斗长袍，一张略带沧桑的英俊脸，双手负背，一种浓浓的威压向着场地四周扩散开来，不可一世，立于天地之间，不败风范，这就是族长。“大家肃静！！”一道响亮的声音突然在大众的耳边炸响，随即硕大的比赛场中转瞬安静，这就是族长的威信，“今天是一个展现自身实力的时刻，在距上一届比赛五年后，第二届古界资格比赛再一次开启，这一次我不想再多说什么。”一种雄厚的声音再一次在耳边响起，接至而来的更使大家热血沸腾“我只想告诉各位，这一次年轻天才汇聚，这是一次无与伦比的比赛，这是展现你们热血，志向，实力的一刻，希望你们不要留下遗憾，在这一次的比赛之后我会收一个关门弟子，希望你们能在这次比赛中大放光彩！”话音一落，赛场上顿时射血沸腾，谁不想成为族长弟子，谁不想一气冲天。就在这嘈杂时刻族长用一个更为洪亮的声音宣布“比赛开始”，随即在赛场顶端悬挂的古朴道钟莫名响起，这钟声厚重圆润，仿佛能安抚众人激动的心情，这也正式宣布比赛开始！！！两天时间说快不快说慢不慢，眨眼间就过去了。 此时还正在凌晨不过魂界内因为族内比赛的这件事都变得热闹非凡。在报名台前，来报名参加比赛的人也是排起了长龙，一个个雄心壮志。但人数实在是太过庞大，于是长老会不得不商议决定，只有15岁以下，天命一阶以上的人才能参加比赛，这规定一出顿时就刷下了许多人，可人数依旧众多。这时离正式的比赛时间只有八个小时，所有幕后台前的工作都在紧锣密鼓的进行着，这时的魂蚀咗也在自己修炼的密室中缓缓睁开双目，顺势吐出一口浊气，站起来伸了个懒腰“呼，坐了整整两天两夜，腰酸背痛的”与此同时他斜眼看了看窗外“咦，快要开赛了，出去逛逛再去比赛场应该时间刚刚好吧。”密室厚重的石门缓缓开启。这石门可以屏蔽各种声音打扰为修炼者提供一个良好的修炼条件，不然在深度修炼状态的被毫无防备的干扰是有可能走火入魔的，这些常识问题魂少可是做的很好的，不过代价也是相当大的，拿钱的数字就不是一般人所能承受的。所谓的深度修炼就是处于感悟天地规则和顿悟的时候，不然平时的吸取天地灵气只能算是浅度修炼，浅度修炼被意外打扰并没有什么大问题。当石门打开，走出石门眼前便是一座恢弘的的城池，一眼望不到边。魂蚀咗的居住地可是魂界的高山上，不仅灵气相对更加浓厚风景也是数一数二的，当然也只有族长的子女才有这等的修炼条件。石门缓缓开启后又逐渐关闭，魂少御气而行，双脚离地如一道风一般向山下行去。到了天命这个等级就可以用自身的内力把自身托离地面少许，即使是少许也足矣增加行进速度了，不过刚刚到达天命级别的人只能勉强使用，只有实力越高才能用得更加熟练，现在魂少处于天命三阶中期，也可以进行熟练的操作了，一切都是建立在实力之上。刚一下山，就吸引了大批众人的目光，“咦！那不是魂蚀咗，魂少吗？”“是啊是啊，好帅”顿时就引来一群“无知少女”的围观，甚至于还有人来要签名的，魂蚀咗看她们如此热情自己那小小的虚荣心瞬间就升腾起来了，毫不犹豫的就答应了。众女一瞧，“我也要！”“给我签一个！”“魂少，这里这里！”就因为他这个小小的举动引起了大家的骚动，面前的路已经完全被阻挡，魂蚀咗此时的心情十分苦闷啊，在这里又不敢随意使用内力，容易伤及无辜呀。于是乎，不可一世的魂少主被一群少女追得抱头鼠窜，狼狈不堪，这时修炼人的敏捷和耐力就体现出来了，虽然路途艰苦可好歹跑出来了呀，不得已他只得将自己的面容改变.本来一脸英气的脸，变得萌萌哒，一双大大水汪汪的眼睛扑闪扑闪的，还略带一点婴儿肥，修长的身材也稍稍变矮了一些，“这下可没人认得出我了吧！”那人畜无害的脸上露出一种得意的笑容。嘿，不巧的是这一幕被恰好出关的魂诗羽给瞧见了，她叫一个乐啊，这小子谁叫你平时装帅装酷的，这下知道厉害了吧。乐归乐，望望天色也不早了，该前往比赛场了，小子努力吧！随即便以天命五阶初期的实力双脚离地腾空而起，化为一道飓风般的速度向着比赛场的位置离去，那速度比魂蚀咗都还要快上不少，不然比魂蚀咗高出的两阶是吃素的啊！这时的魂易天还在报名的长龙里，这时离开始比赛还有1个小时，但好在魂易天前面没几人了，用不了几分钟就可以报名参加比赛了。说巧不巧，魂蚀咗就在此时从一个豪华通道直接进入会场，魂易天十分鄙夷，凭什么我们就得排队，凭什么我们就得等这么久，凭什么他就能直接进入会场，就因为他的地位比我们高，就因为他是族长的儿子！！！哼，魂蚀咗，你等着，我会将你打败，我要向世人证明，就算是出身平凡依旧可以璀璨夺目。魂易天的内心虽然正在惊涛骇浪，但毫无面部表情，依旧是一副平淡无奇的样子。填完报名表的魂易天也缓步走进比赛场但他还是下意识的向vip通道看去。此时的魂诗羽也到了，看见了魂易天正望向这一边，出于礼貌魂诗羽对他淡淡一笑，可他依旧是一副波澜不惊的样子转身离去。这引得魂诗羽撇了撇眉，这小子看着挺不简单的啊，看来这次大会有的一拼了。然后也转身进入比赛场。魂族的比赛场呈椭圆形犹如一个巨大的太阳，金碧辉煌。比赛场内，可以容纳三十多万人的位置此时也是座无虚席，在观众席的中的一般都是未修练的普通人或等级比较低的人。在观众席中央便是比赛场地，由坚硬的花岗岩石铺成，同时还有族长亲自施下的符文用于进一步加固比赛场地。一道金光闪耀，比赛场中央升起一道金柱，当光芒散去后，大众才看清金柱的正面目，一条条巨龙盘旋于上，苍劲的身躯，直冲上青天，青天之中有一颗光彩夺目的龙珠，互相争夺，活灵活现犹如有生命一般，并且整个黄金柱还在不断的吞吐天地灵气，发出瑞光。族长则屹立在黄金柱上身穿一件纯黑色的战斗长袍，一张略带沧桑的英俊脸，双手负背，一种浓浓的威压向着场地四周扩散开来，不可一世，立于天地之间，不败风范，这就是族长。“大家肃静！！”一道响亮的声音突然在大众的耳边炸响，随即硕大的比赛场中转瞬安静，这就是族长的威信，“今天是一个展现自身实力的时刻，在距上一届比赛五年后，第二届古界资格比赛再一次开启，这一次我不想再多说什么。”一种雄厚的声音再一次在耳边响起，接至而来的更使大家热血沸腾“我只想告诉各位，这一次年轻天才汇聚，这是一次无与伦比的比赛，这是展现你们热血，志向，实力的一刻，希望你们不要留下遗憾，在这一次的比赛之后我会收一个关门弟子，希望你们能在这次比赛中大放光彩！”话音一落，赛场上顿时射血沸腾，谁不想成为族长弟子，谁不想一气冲天。就在这嘈杂时刻族长用一个更为洪亮的声音宣布“比赛开始”，随即在赛场顶端悬挂的古朴道钟莫名响起，这钟声厚重圆润，仿佛能安抚众人激动的心情，这也正式宣布比赛开始！！！";
    
    self.totalPage = 0;
    self.currentPage = 0;
    
    
    self.pageManager = [[E_Paging alloc]init];
    self.pageManager.contentText = str;
    self.pageManager.contentFont = 12;
    self.pageManager.textRenderSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-120);
    [self.pageManager paginate];
    self.textArray = [NSMutableArray array];
    for(int i=1;i<=self.pageManager.pageCount;i++)
    {
        [self.textArray addObject:[self.pageManager stringOfPage:i]];
    }
    

    [self setscorller];
}



-(void)getTextDate
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//设置滚动视图
-(void)setscorller
{
    UIScrollView *scroller = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scroller.backgroundColor = [UIColor redColor];
    scroller.delegate = self;
    scroller.pagingEnabled = YES;
    scroller.bounces = NO;
    //不显示水平滚动条
    scroller.showsHorizontalScrollIndicator = NO;
    scroller.contentSize = CGSizeMake(SCREEN_WIDTH * 3, self.view.bounds.size.height);
    
    for(int i = 0;i<self.LabelsArray.count;i++)
        
    {
        UILabel *textLabel = self.LabelsArray[i];
        textLabel.font = [UIFont systemFontOfSize:12.f];
        textLabel.numberOfLines = 0;
        textLabel.text = [self.pageManager stringOfPage:i%_pageManager.pageCount];
        
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:textLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:6];//行距的大小
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textLabel.text.length)];
        textLabel.attributedText = attributedString;
        [textLabel sizeToFit];
        
        [scroller addSubview:textLabel];
    }
    self.lastX = SCREEN_WIDTH;
    
    //从中间开始显示
    [scroller setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    
    [self.view addSubview:scroller];
    self.MainScroller = scroller;
    self.MainScroller.delegate = self;
    
}

/**
 *  滚动停止
 *
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x>SCREEN_WIDTH)
    {
        [self scrollViewEndScroll:scrollView];
    }
}


- (void)scrollViewEndScroll:(UIScrollView *)scrollView
{
    CGFloat contentX = scrollView.contentOffset.x;
    
    BOOL isRight = (contentX - self.lastX > 0);
    
    [self adjustBannerImage:isRight];
    [self adjustBanner];
}

//调校图片
- (void) adjustBannerImage:(BOOL) isRight
{
    int lastIndex = (int)self.textArray.count - 1;
    //  右往左滑，数据数组向后移动一位
    if(isRight)
    {
        NSString *url = self.textArray[0];
        for(int i = 0;i<self.textArray.count;i++)
        {
            self.textArray[i] = i==lastIndex? url:self.textArray[i+1];
        }
    }
    //左向右滑动时
    else
    {
        NSString *url = self.textArray[lastIndex];
        for(int i = lastIndex;i>=0;i--)
        {
            self.textArray[i] = i==0? url:self.textArray[i-1];
        }
    }
    for(int i=0;i<self.LabelsArray.count;i++)
    {
        UILabel *textlabel = self.LabelsArray[i];
        textlabel.text = self.textArray[i%self.textArray.count];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:textlabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:6];//行距的大小
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textlabel.text.length)];
        textlabel.attributedText = attributedString;
        [textlabel sizeToFit];
    }
    
}

- (void) adjustBanner
{
    [self.MainScroller setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
}






//懒加载初始化，在复用数组中有三个imageview
-(NSMutableArray *)LabelsArray
{
    if(!_LabelsArray)
    {
        self.LabelsArray = [NSMutableArray array];
        for(int i =0;i<3;i++)
        {
            UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
            [self.LabelsArray addObject:textLabel];
        }
    }
    return _LabelsArray;
}

@end

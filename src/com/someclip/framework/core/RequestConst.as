package consts
{

	/**
	 * 通讯协议常量表
	 * @author Argus
	 *
	 */
	public class RequestConst
	{
		/**
		 * US登录请求
		 */
		public static const US_LOGIN:String="us_login";
		/**
		 * MS登录请求
		 */
		public static const MS_LOGIN:String="ms_login";

		/**
		 * 获取服务器时间戳
		 */
		public static const SEVER_TIME:String="server_time";

		/**
		 * 获取用户信息
		 */
		public static const GET_USER_INFO:String="get_user_info";

		/**
		 * 更新用户信息
		 */
		public static const UPDATE_USER_INFO:String="update_user_info";

		/**
		 * 获取竞技广场中光荣榜的数据（前6名还有自己的排名）
		 */
		public static const GET_TOP6_RANK:String="get_top6_rank";

		/**
		 * 获取用户钻石数量
		 */
		public static const GET_DIAMOND_CNT:String="get_diamond_cnt";

		/**
		 * 获取计划课程列表
		 */
		public static const GET_COURSE_PLAN:String="get_course_plan";

		/**
		 * 获取题目
		 */
		public static const START_EXAM:String="start_exam";

		/**
		 * 获取题目
		 */
		public static const GET_QUES:String="get_questions";

		/**
		 * 处理答题结果
		 */
		public static const HAND_QUES_RESULT:String="hand_ques_result";

		/**
		 * 请求课堂测试的结果
		 */
		public static const GET_EXAM_RESULT:String="get_exam_result";

		/**
		 * 开始竞赛
		 */
		public static const START_RACE:String="start_race";
		/**
		 * 保存竞赛每关的得分、时间
		 */
		public static const SAVE_RACEGAME_SCORE:String="save_racegame_Score";
		/**
		 * 请求竞赛的结果
		 */
		public static const GET_RACE_RESULT:String="get_race_result";

		/**
		 * 获取宠物信息
		 */
		public static var GET_PET_INFO:String="get_pet_info";

		/**
		 *创建宠物
		 */
		public static var CREATE_PET:String="create_pet";

		/**
		 * 获取宠物装备
		 */
		public static var GET_PET_EQUIPMENT:String="get_pet_equipment";

		/**
		 * 更新宠物装备
		 */
		public static var MOVE_ITEM:String="move_item";

		/**
		 * 获取宠物技能
		 */
		public static var GET_PET_SKILL:String="get_pet_skill";

		/**
		 * 获取宠物背包数据
		 */
		public static var GET_PET_BAG:String="get_pet_bag";

		/**
		 * 移动技能
		 */
		public static var MOVE_PET_SKILL:String="move_pet_skill";

		public function RequestConst()
		{
		}
	}
}

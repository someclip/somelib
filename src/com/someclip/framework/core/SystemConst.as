package com.someclip.framework.core
{

	public class SystemConst
	{
		/**
		 * 创建模块
		 */
		public static const CREATE_VIEW:String="create_view";
		/**
		 * 模块创建成功
		 */
		public static const VIEW_CREATED:String="view_created";
		/**
		 * 请求进度条
		 */
		public static const REQUIRE_PROGRESS:String="require_progress";
		/**
		 * 隐藏进度条
		 */
		public static const HIDE_PROGRESS:String="hide_progress";
		/**
		 * 抽出进度条，即在有进度条的时候强制停止显示进度条
		 */
		public static const DRAW_PROGRESS:String="draw_progress";
		/**
		 * 发送请求到服务器HTTP
		 */
		public static const SEND_REQUEST:String="send_request";

		/**
		 * 发生系统错误
		 */
		public static const SYS_ERROR_OCCUR:String="sys_error_occur";

		public function SystemConst()
		{
		}
	}
}

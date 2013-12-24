package com.someclip.utils.load 
{
	/**
	 * 数据类型
	 * @author Argus
	 */
	public class DataType 
	{
		/**
		 * 字符数据
		 */
		public static const DATA_STRING:String = 'data_string';
		/**
		 * 字节流数据
		 */
		public static const DATA_BYTE:String = 'data_byte';
		/**
		 * 值对数据
		 */
		public static const DATA_VAR:String = 'data_var';
		/**
		 * 图形对象
		 */
		public static const CONTENT_IMAGE:String = 'content_image';
		/**
		 * 直接显示的对象
		 */
		public static const CONTENT_SWF_NO_CODE:String = 'content_swf_no_code';
		/**
		 * 通过反射获取内容的对象
		 */
		public static const CONTENT_SWF_CODE:String = 'content_swf_has_code';
		public function DataType() 
		{
			
		}
		
	}

}
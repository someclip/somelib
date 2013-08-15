package com.someclip.framework.core
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedSuperclassName;

	public class BaseVO
	{
		public function BaseVO()
		{
		}

		/**
		 * 将data的所有属性值赋予当前对象同名的（如果有）属性。如果发现有赋值失败的，请检查属性名是否一致。
		 * @param data 目标对象
		 *
		 */
		public function parse(data:Object):void
		{
			var xml:XML=describeType(this);
			var vars:XMLList=xml.child("variable");
			for each (var child:XML in vars)
			{
				if (data.hasOwnProperty(child.@name))
				{
					this[child.@name]=data[child.@name];
				}
			}
		}

		public function parseXML(data:XML):void
		{

		}
	}
}

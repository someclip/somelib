package com.someclip.framework.core
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedSuperclassName;

	public class BaseVO
	{
		public function BaseVO()
		{
		}

		public function parse(data:Object):void
		{
			if (getQualifiedSuperclassName(data) == null)
			{
				for (var n:String in data)
				{
					if (this.hasOwnProperty(n))
					{
						this[n]=data[n];
					}
				}
			}
			else
			{
				var xml:XML=describeType(data);
				var vars:XMLList=xml.child("variable");
				for each (var child:XML in vars)
				{
					if (this.hasOwnProperty(child.@name))
					{
						this[child.@name]=data[child.@name];
					}
				}
			}
		}

		public function parseXML(data:XML):void
		{

		}
	}
}

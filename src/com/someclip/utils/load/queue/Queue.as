package com.someclip.utils.load.queue
{
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	
	/**
	 * ...
	 * @author Argus
	 */
	public class Queue implements IQueue
	{
		private static var _queueId:int;
		private var _showProgress:Boolean;
		private var _queueTitle:String;
		private var _queueMethod:String;
		private var _queueParam:Object;
		private var _dataType:String;
		private var _applicationDomain:ApplicationDomain;
		private var _queueURL:String;
		private var _queueHandler:Function;
		private var _data:Object;
		private var _content:DisplayObject;
		private var _statue:int;
		
		public function Queue()
		{
			_queueId++;
		}
		
		/* INTERFACE com.someclip.utils.load.queue.IQueue */
		
		public function get queueId():int
		{
			return _queueId;
		}
		public function get showProgress():Boolean
		{
			return _showProgress;
		}
		
		public function set showProgress(value:Boolean):void
		{
			_showProgress = value;
		}
		public function get queueTitle():String
		{
			return _queueTitle;
		}
		
		public function set queueTitle(value:String):void
		{
			_queueTitle = value;
		}
		
		public function get queueMethod():String
		{
			return _queueMethod;
		}
		
		public function set queueMethod(value:String):void
		{
			_queueMethod = value;
		}
		
		public function get queueParam():Object
		{
			return _queueParam;
		}
		
		public function set queueParam(value:Object):void
		{
			_queueParam = value;
		}
		
		public function get dataType():String
		{
			return _dataType;
		}
		
		public function set dataType(value:String):void
		{
			_dataType = value;
		}
		
		public function get applicationDomain():ApplicationDomain
		{
			return _applicationDomain;
		}
		
		public function set applicationDomain(value:ApplicationDomain):void
		{
			_applicationDomain = value;
		}
		
		public function get queueURL():String
		{
			return _queueURL;
		}
		
		public function set queueURL(value:String):void
		{
			_queueURL = value;
		}
		
		public function get queueHandler():Function
		{
			return _queueHandler;
		}
		
		public function set queueHandler(value:Function):void
		{
			_queueHandler = value;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		public function get content():DisplayObject
		{
			return _content;
		}
		
		public function set content(value:DisplayObject):void
		{
			_content = value;
		
		}
		
		public function get statue():int
		{
			return _statue;
		}
		
		public function set statue(value:int):void
		{
			_statue = value;
		}
	}

}
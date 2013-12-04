package com.someclip.utils.load
{
	import com.someclip.utils.cache.CacheManager;
	import com.someclip.utils.queue.IQueueItem;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	public class DataLoader extends URLLoader implements ILoader
	{
		private var _info:IQueueItem;
		private var _doneHandler:Function;

		public function DataLoader()
		{
			bindListener();
		}

		private function bindListener():void
		{
			this.addEventListener(Event.COMPLETE, completedHandler);
			this.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityHandler);
			this.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatueHandler);
		}

		private function httpStatueHandler(event:HTTPStatusEvent):void
		{
			if (event.status != 200)
				trace("httpstatue:", event);
		}

		public function get boardcastor():EventDispatcher
		{
			return this;
		}

		public function startLoad(value:IQueueItem, doneHandler:Function=null):void
		{
			_info=null;
			_doneHandler=null;
			_info=value;
			_doneHandler=doneHandler;

			var request:URLRequest=new URLRequest();
			var seted:Boolean=false;
			if (_info.itemVars != null)
			{
				var itemVars:URLVariables=new URLVariables();
				for (var label:String in _info.itemVars)
				{
					if (label == "dataFormat")
					{
						seted=true;
						super.dataFormat=_info.itemVars[label];
					}
					else if (label == "method")
					{
						request.method=_info.itemVars[label];
					}
					else
					{
						itemVars[label]=_info.itemVars[label];
					}
				}
				//itemVars.foo=Math.random();
				request.data=itemVars;
				itemVars=null;
			}
			if (seted == false)
			{
				if (_info.itemType == LoadType.DATA_VARS)
				{
					super.dataFormat=URLLoaderDataFormat.VARIABLES;
				}
				else
				{
					super.dataFormat=URLLoaderDataFormat.TEXT;
				}
			}
			if (request.data && request.data.toString() == "")
			{
				request.data=null;
			}
			request.url=_info.itemURL;
			if (request.data)
			{
				trace(request.url + "?" + request.data.toString());
			}
			else
			{
				trace(request.url);
			}
			super.load(request);
			request=null;
		}

		override public function load(request:URLRequest):void
		{
			trace("请使用startLoad方法！");
		}

		private function securityHandler(event:SecurityErrorEvent):void
		{
			_info.done=-2;
			if (_info.completeHandler != null)
			{
				_info.completeHandler(_info);
				_info=null;
			}
			if (_doneHandler != null)
			{
				_doneHandler();
			}
		}

		private function ioErrorHandler(event:IOErrorEvent):void
		{
			//trace(event.toString())
			_info.done=-1;
			if (_info.completeHandler != null)
			{
				_info.completeHandler(_info);
				_info=null;
			}
			if (_doneHandler != null)
			{
				_doneHandler();
			}
		}

		private function completedHandler(event:Event):void
		{
			_info.done=1;
			var data:Object=super.data;
			super.data=null;
			CacheManager.instance.store(_info.cacheKey, data, CacheManager.STORE_ONCE);
			data=null;
			if (_info.completeHandler != null)
			{
				_info.completeHandler(_info);
				_info=null;
			}
			if (_doneHandler != null)
			{
				_doneHandler();
			}
		}

		public function stop():void
		{
			try
			{
				super.close();
			}
			catch (e:*)
			{

			}
		}

		public function destroy():void
		{
		}
	}
}

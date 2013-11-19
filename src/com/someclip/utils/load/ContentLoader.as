package com.someclip.utils.load
{
	import com.someclip.utils.cache.CacheManager;
	import com.someclip.utils.queue.IQueueItem;

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.system.System;

	public class ContentLoader extends Loader implements ILoader
	{
		private var _info:IQueueItem;
		private var _doneHandler:Function;
		private var _domain:ApplicationDomain;
		private var _inited:Boolean;

		public function ContentLoader()
		{

			bindListener();
		}

		private function bindListener():void
		{
			super.contentLoaderInfo.addEventListener(Event.COMPLETE, completedHandler);
			super.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			super.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityHandler);
		}

		public function get boardcastor():EventDispatcher
		{
			return super.contentLoaderInfo;
		}

		public function startLoad(value:IQueueItem, doneHandler:Function=null):void
		{
			_info=null;
			_doneHandler=null;
			_domain=null;
			_inited=false;
			_info=value;
			_doneHandler=doneHandler;
			var context:LoaderContext=new LoaderContext();
			if (Security.sandboxType == Security.REMOTE)
			{
				context.securityDomain=SecurityDomain.currentDomain;
			}
			if (_info.applicationDomain == null)
			{
				if (_info.itemType == LoadType.CODE)
				{
					//context.applicationDomain=new ApplicationDomain(ApplicationDomain.currentDomain);
					context.applicationDomain=ApplicationDomain.currentDomain;
					_info.applicationDomain=context.applicationDomain;
				}
				else
				{
					context.applicationDomain=ApplicationDomain.currentDomain;
					_info.applicationDomain=context.applicationDomain;
				}
			}
			else
			{
				context.applicationDomain=_info.applicationDomain;
			}
			_domain=context.applicationDomain;
			super.load(new URLRequest(_info.itemURL), context);
			context=null;
		}

		private function securityHandler(event:Event):void
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
			_info.done=-1
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

		private function completedHandler(event:Event=null):void
		{
			trace("loaded:", _info.itemURL);
			_info.done=1;
			if (_info.itemType == LoadType.CONTENT)
			{
				var dso:Object=super.content;
				if (dso is MovieClip)
					(dso as MovieClip).gotoAndStop(1);
				CacheManager.instance.store(_info.cacheKey, dso, CacheManager.STORE_ONCE);
				_domain=null;
				dso=null;
			}
			else
			{
				CacheManager.instance.store(_info.cacheKey, null, CacheManager.STORE_ONCE, _domain);
				_domain=null;
			}
			super.unload();
			if (_info.completeHandler != null)
			{
				_info.completeHandler(_info);
			}
			_info=null;
			if (_doneHandler != null)
			{
				_doneHandler();
			}
		}

		override public function load(request:URLRequest, context:LoaderContext=null):void
		{
			trace("请使用startLoad方法！");
		}

		public function destroy():void
		{
		}
	}
}

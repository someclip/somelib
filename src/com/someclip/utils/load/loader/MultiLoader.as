package com.someclip.utils.load.loader
{
	import com.someclip.utils.load.DataType;
	import com.someclip.utils.load.queue.IQueue;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Argus
	 */
	public class MultiLoader extends EventDispatcher implements ILoader
	{
		private var _queue:IQueue;
		private var _preLoader:URLLoader;
		private var _posLoader:Loader;
		private var _free:Boolean;
		private var _progressHandler:Function;
		public function MultiLoader()
		{
			_free = true;
		}
		
		/* INTERFACE com.someclip.utils.load.loader.ILoader */
		public function get progressHandler():Function
		{
			return _progressHandler;
		}
		
		public function set progressHandler(value:Function):void
		{
			_progressHandler = value;
		}

		public function startLoad(queue:IQueue):void
		{
			if (!_free)
			{
				return;
			}
			_free = false;
			trace("开始从:",queue.queueURL,"   获取内容");
			_queue = queue;
			preLoad();
		}
		
		private function preLoad():void
		{
			if ((_queue.queueURL == null || _queue.queueURL == "") && _queue.data==null)
			{
				_queue.statue = 0;
				doneHandler();
				return;
			}
			if (_queue.dataType == null || _queue.dataType == "")
			{
				_queue.statue = 0;
				doneHandler();
				return;
			}
			if (_queue.queueTitle == null || _queue.queueTitle == "")
			{
				switch (_queue.dataType)
				{
					case DataType.DATA_STRING: 
					case DataType.DATA_VAR: 
						_queue.queueTitle = "数据";
						break;
					default: 
						_queue.queueTitle = "资源";
						break;
				}
			}
			switch(_queue.dataType)
			{
				case DataType.CONTENT_SWF_CODE_FROM_DATA:
				case DataType.CONTENT_SWF_NO_CODE_FROM_DATA:
					posLoad();
					break;
				default:
					startPreLoad();
					break;
			}
			
		}
		
		private function startPreLoad():void
		{
			_preLoader = new URLLoader();
			var request:URLRequest = new URLRequest();
			request.url = _queue.queueURL;
			if (_queue.queueMethod != null && _queue.queueMethod != "")
			{
				request.method = _queue.queueMethod;
			}
			if (_queue.queueParam != null)
			{
				var uvar:URLVariables = new URLVariables();
				for (var pro:String in _queue.queueParam)
				{
					uvar[pro] = _queue.queueParam[pro];
				}
				request.data = uvar;
			}
			_preLoader.addEventListener(Event.COMPLETE, handlePreLoaderComplete);
			_preLoader.addEventListener(IOErrorEvent.IO_ERROR, handlePreLoaderIoError);
			_preLoader.addEventListener(ProgressEvent.PROGRESS,handlePreloaderProgress);
			_preLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handlePreLoaderSecurityError);
			switch (_queue.dataType)
			{
				case DataType.DATA_STRING: 
					_preLoader.dataFormat = URLLoaderDataFormat.TEXT;
					break;
				case DataType.DATA_VAR:
					_preLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
					break;
				default:
					_preLoader.dataFormat = URLLoaderDataFormat.BINARY;
					break;
			}
			_preLoader.load(request);
			request = null;
		}
		
		private function handlePreloaderProgress(event:ProgressEvent):void
		{
			if(_progressHandler!=null)
			{
				_progressHandler(_queue.queueTitle,_queue.queueTitle,event.clone());
			}
		}
		
		private function handlePreLoaderSecurityError(e:SecurityErrorEvent):void
		{
			trace("security error");
			clearPreLoader();
		}
		
		private function handlePreLoaderIoError(e:IOErrorEvent):void
		{
			trace("io error");
			clearPreLoader();
			_queue.statue = 0;
			if (_queue.queueHandler != null)
			{
				_queue.queueHandler(_queue);
			}
			if (doneHandler != null)
			{
				doneHandler();
			}
		}
		
		private function handlePreLoaderComplete(e:Event):void
		{
			_queue.data = _preLoader.data;
			if(_queue.dataType==DataType.DATA_STRING)
			{
				trace("取得数据：",String(_queue.data).substr(0,100),"   来自:",_queue.queueURL)
			}
			_queue.statue = 1;
			clearPreLoader();
			switch (_queue.dataType)
			{
				case DataType.DATA_STRING: 
				case DataType.DATA_VAR:
				case DataType.DATA_BYTE:
					doneHandler();
					break;
				default:
					posLoad();
					break;
			}
		}
		
		private function clearPreLoader():void 
		{
			try
			{
				_preLoader.close();
			}catch (e:Error)
			{
				trace(e);
			}
			_preLoader.removeEventListener(Event.COMPLETE, handlePreLoaderComplete);
			_preLoader.removeEventListener(IOErrorEvent.IO_ERROR, handlePreLoaderIoError);
			_preLoader.removeEventListener(ProgressEvent.PROGRESS,handlePreloaderProgress);
			_preLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handlePreLoaderSecurityError);
			_preLoader = null;
		}
		
		private function posLoad():void 
		{
			_posLoader = new Loader();
			_posLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handlePosLoaderComplete);
			var lc:LoaderContext = new LoaderContext();
			//lc.allowCodeImport = true;
//			if (Security.sandboxType == Security.REMOTE)
//			{
//				lc.securityDomain = SecurityDomain.currentDomain;
//			}
			if (_queue.applicationDomain == null)
			{
				lc.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
				_queue.applicationDomain = lc.applicationDomain;
			}else
			{
				lc.applicationDomain = _queue.applicationDomain;
			}
			_posLoader.loadBytes(_queue.data as ByteArray, lc);
			lc = null;
		}
		
		private function handlePosLoaderComplete(e:Event):void 
		{
			trace("从：",_queue.queueURL," 获取内容成功")
			try
			{
				_queue.content = _posLoader.content as DisplayObject;
			}catch (e:Error)
			{
				trace(e);
			}
			if (_queue.content != null && _queue.content is MovieClip)
			{
				(_queue.content as MovieClip).gotoAndStop(1);
			}
			clearPosLoader();
			doneHandler();
		}
		
		private function clearPosLoader():void 
		{
			try
			{
				_posLoader.unload();
			}catch(e:Error)
			{
				trace(e);
			}
			_posLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handlePosLoaderComplete);
			_posLoader = null;
		}
		
		private function doneHandler():void
		{
			if (_queue.queueHandler != null)
			{
				_queue.queueHandler(_queue);
			}
			_queue = null;
			_free = true;
			dispatchEvent(new Event("QUEUE_DONE"));
		}
		
		public function stopAndQuit():void
		{
			if(_preLoader!=null)
			{
				clearPreLoader();
			}
			if(_posLoader!=null)
			{
				clearPosLoader();
			}
			if(_queue)
			{
				_queue=null;
			}
			_free=true;
		}
		
		public function get free():Boolean 
		{
			return _free;
		}
	
	}

}
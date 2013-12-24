package com.someclip.utils.load.loader 
{
	import com.someclip.utils.load.queue.IQueue;
	
	/**
	 * loader接口
	 * @author Argus
	 */
	public interface ILoader 
	{
		function startLoad(queue:IQueue):void;
		function stopAndQuit():void;
	}
	
}
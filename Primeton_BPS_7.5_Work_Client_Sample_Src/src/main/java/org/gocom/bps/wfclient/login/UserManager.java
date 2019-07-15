package org.gocom.bps.wfclient.login;

import java.util.concurrent.locks.ReentrantReadWriteLock;

import javax.servlet.http.HttpSession;

import com.eos.data.datacontext.IUserObject;
import com.eos.data.datacontext.UserObject;

public class UserManager {
	
	//=true的时候,写锁执行,所有的读锁会被堵塞
		//=false的时候,写锁执行,读锁不会被堵塞
		private static ReentrantReadWriteLock lock = new ReentrantReadWriteLock(true);

		private static ReentrantReadWriteLock.ReadLock readLock = lock.readLock();

	
	/**
	 * 判断是否已经登录
	 * 
	 * @param session
	 * @return
	 */
	public static boolean isLogin(HttpSession session) {
		readLock.lock();
		try {
			if (session == null) {
				return false;
			}
			UserObject user = (UserObject) session.getAttribute(IUserObject.KEY_IN_CONTEXT);
			if (user == null) {
				return false;
			}
			if (user.getUserId() == null) {
				return false;
			}
			return true;
		} finally {
			readLock.unlock();
		}
	}
	
	

}

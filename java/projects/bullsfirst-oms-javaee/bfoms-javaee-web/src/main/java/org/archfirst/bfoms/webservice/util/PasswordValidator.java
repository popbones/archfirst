package org.archfirst.bfoms.webservice.util;

import com.sun.xml.wss.impl.callback.PasswordValidationCallback;
import com.sun.xml.wss.impl.callback.PasswordValidationCallback.PasswordValidationException;
import com.sun.xml.wss.impl.callback.PasswordValidationCallback.Request;

public class PasswordValidator implements PasswordValidationCallback.PasswordValidator
{
//    @Inject SecurityService securityService;
    
    @Override
    public boolean validate(Request request) throws PasswordValidationException {
//        PasswordValidationCallback.PlainTextPasswordRequest passwordRequest
//            = (PasswordValidationCallback.PlainTextPasswordRequest)request;
//        String username = passwordRequest.getUsername();
//        String password = passwordRequest.getPassword();
//        return securityService.authenticateUser(username, password).isSuccess();
        return true;
    }
}
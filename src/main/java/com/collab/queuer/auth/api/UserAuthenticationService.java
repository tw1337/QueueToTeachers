package com.collab.queuer.auth.api;

import com.collab.queuer.model.User;

import java.util.Optional;

public interface UserAuthenticationService {
    Optional<String> login(String username, String password);


    Optional<User> findByToken(String token);

    //hz ksta
    void logout(User user);
}

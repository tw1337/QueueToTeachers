package com.collab.queuer.service;

import com.collab.queuer.model.User;

import java.util.Optional;

//мб удалю кста
public interface UserService {

    User save(User user);

    //may be refactor?
    Optional<User> find(Long id);

    Optional<User> findByLogin(String login);
}

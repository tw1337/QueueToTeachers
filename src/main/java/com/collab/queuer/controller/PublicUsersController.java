package com.collab.queuer.controller;

import com.collab.queuer.auth.api.UserAuthenticationService;
import com.collab.queuer.service.UserService;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.NonNull;
import lombok.experimental.FieldDefaults;
import com.collab.queuer.model.User;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequestMapping("/public/users")
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@AllArgsConstructor(access = AccessLevel.PACKAGE)
public class PublicUsersController {
    @NonNull
    UserAuthenticationService authentication;
    @NonNull
    UserService userService;


    @PostMapping("/register")
    String register(@RequestBody User newUser) {
        userService.save(newUser);
        return login(newUser.getUsername(), newUser.getPassword());
    }

    @PostMapping("/login")
    String login(
            @RequestParam("username") final String username,
            @RequestParam("password") final String password) {
        return authentication
                .login(username, password)
                .orElseThrow(() -> new RuntimeException("invalid login and/or password"));
    }
}

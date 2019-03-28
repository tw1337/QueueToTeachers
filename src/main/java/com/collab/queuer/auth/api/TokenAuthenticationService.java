package com.collab.queuer.auth.api;

import com.collab.queuer.model.User;
import com.collab.queuer.service.UserService;
import com.collab.queuer.token.api.TokenService;
import lombok.AllArgsConstructor;
import lombok.NonNull;
import lombok.experimental.FieldDefaults;
import org.springframework.stereotype.Service;
import com.google.common.collect.ImmutableMap;

import java.util.Map;
import java.util.Objects;
import java.util.Optional;

import static lombok.AccessLevel.PACKAGE;
import static lombok.AccessLevel.PRIVATE;

@Service
@AllArgsConstructor(access = PACKAGE)
@FieldDefaults(level = PRIVATE, makeFinal = true)
final class TokenAuthenticationService implements UserAuthenticationService {
    @NonNull
    TokenService tokens;
    @NonNull
    UserService users;

    @Override
    public Optional<String> login(final String username, final String password) {
        return users.findByLogin(username)
                .filter(user -> Objects.equals(password, user.getPassword()))
                .map(user -> tokens.expiring(ImmutableMap.of("username", username)));
    }

    @Override
    public Optional<User> findByToken(final String token) {
//        return Optional
//                .of(tokens.verify(token))
//                .map(map -> map.get("username"))
//                .flatMap(users::findByLogin);
        Map<String, String> map = tokens.verify(token);
        map.get("username");
        return users.findByLogin(map.get("username"));
    }

    @Override
    public void logout(final User user) {
        // Nothing to doy
    }
}

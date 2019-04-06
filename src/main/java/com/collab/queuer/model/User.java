package com.collab.queuer.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Value;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;


import javax.persistence.*;
import javax.validation.constraints.NotEmpty;
import java.util.ArrayList;
import java.util.Collection;

@Entity
@Table(name = "users")
public class User implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @Column(name = "username")
    @NotEmpty
    @JsonProperty
    String username;

    //may be sha or smtng?
    @Column(name = "password")
    @NotEmpty
    @JsonIgnore
    String password;


    @Column(name = "studentname")
    @NotEmpty
    @JsonProperty
    String studentName;

    @Column(name = "studentsurname")
    @NotEmpty
    @JsonProperty
    String studentSurname;

    @Column(name = "studentgroup")
    @NotEmpty
    @JsonProperty
    String studentGroup;


    @JsonCreator
    public User(@JsonProperty("username") final String username,
                @JsonProperty("password") final String password,
                @JsonProperty("studentName") final String studentName,
                @JsonProperty("studentSurname") final String studentSurname,
                @JsonProperty("studentGroup") final String studentGroup) {
        super();
        this.username = username;
        this.password = password;
        this.studentName = studentName;
        this.studentSurname = studentSurname;
        this.studentGroup = studentGroup;
    }


    public User() {
        super();
    }

    @JsonIgnore
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return new ArrayList<>();
    }

    @JsonIgnore
    @Override
    public String getPassword() {
        return password;
    }

    @JsonIgnore
    @Override
    public String getUsername() {
        return username;
    }

    @JsonIgnore
    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @JsonIgnore
    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @JsonIgnore
    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    @JsonIgnore
    public boolean isEnabled() {
        return true;
    }
}

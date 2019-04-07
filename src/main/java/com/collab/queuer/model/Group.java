package com.collab.queuer.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Value;

import javax.persistence.*;
import javax.validation.constraints.NotEmpty;
import java.util.Set;

@Entity
@Table(name = "groups")
public class Group {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @Column(name = "group_name")
    @NotEmpty
    @JsonProperty
    String name;

    @OneToMany(targetEntity = User.class, mappedBy = "studentGroup", cascade = CascadeType.ALL)
    @JsonProperty
    private Set<User> students;

    @JsonCreator
    public Group(@JsonProperty("group_name") final String groupName, @JsonProperty("students") final Set<User> students) {
        this.name = groupName;
        this.students = students;
    }
}

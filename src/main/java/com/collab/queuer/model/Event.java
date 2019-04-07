package com.collab.queuer.model;


import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Value;

import javax.persistence.*;
import javax.validation.constraints.NotEmpty;
import java.time.LocalDate;

@Entity
@Table(name = "events")
@Value
public class Event {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @Column(name = "event_name")
    @NotEmpty
    @JsonProperty
    String name;

    @Column(name = "event_date")
    @NotEmpty
    @JsonProperty
    LocalDate eventDate;

    @ManyToOne
    @JoinColumn(name = "event_owner")
    @NotEmpty
    @JsonProperty
    User eventOwner;

}

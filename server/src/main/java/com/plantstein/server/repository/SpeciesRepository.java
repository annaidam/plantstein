package com.plantstein.server.repository;

import com.plantstein.server.model.Plant;
import com.plantstein.server.model.Species;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;


@Repository
public interface SpeciesRepository extends JpaRepository<Species, String> {
}
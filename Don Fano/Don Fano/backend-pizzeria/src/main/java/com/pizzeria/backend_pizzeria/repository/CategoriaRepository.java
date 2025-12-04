package com.pizzeria.backend_pizzeria.repository;

import com.pizzeria.backend_pizzeria.model.Categoria;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoriaRepository extends JpaRepository<Categoria, Long> {
}
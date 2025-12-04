package com.pizzeria.backend_pizzeria.service;

import com.pizzeria.backend_pizzeria.model.Categoria;
import com.pizzeria.backend_pizzeria.repository.CategoriaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoriaService {

    @Autowired
    private CategoriaRepository categoriaRepository;

    public List<Categoria> getAll() {
        return categoriaRepository.findAll();
    }
}
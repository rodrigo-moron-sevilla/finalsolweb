package com.pizzeria.backend_pizzeria.dto;

import lombok.Data;

@Data
public class LoginRequestDTO {
    private String email;
    private String password;
}
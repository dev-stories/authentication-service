package com.devstories.authservice.controller;

import com.devstories.authservice.service.UserService;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.http.ResponseEntity;

import static org.assertj.core.api.Assertions.assertThat;

class AuthControllerTest {
    private AuthController controller;

    private UserService userService;

    public AuthControllerTest() {
        userService = Mockito.mock(UserService.class);
        this.controller = new AuthController(userService);
    }

    @Test()
    void login() {
        ResponseEntity<Boolean> expected = ResponseEntity.ok(Boolean.TRUE);
        Boolean serviceResponse = Boolean.FALSE;
        Mockito.when(userService.login()).thenReturn(serviceResponse);
       // assertThat(expected).isEqualTo(controller.login());
    }

}

package com.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Random;

@RestController
public class JokeController {

    private final String[] jokes = {
        "Why do DevOps engineers like Halloween? They love haunted servers!",
        "What does a cloud say when overloaded? 'I'm fogging out!'",
        "Why did the Kubernetes pod break up? It needed more 'space'!"
    };

    @GetMapping("/")
    public String getJoke() {
        return "<h1>🚀 Java DevOps ECR</h1><p>" + jokes[new Random().nextInt(jokes.length)] + "</p>";
    }

    @GetMapping("/health")
    public String health() {
        return "OK";
    }
}
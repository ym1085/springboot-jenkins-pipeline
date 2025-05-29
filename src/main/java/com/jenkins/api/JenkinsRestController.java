package com.jenkins.api;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
public class JenkinsRestController {

    @GetMapping("/test")
    public ResponseEntity<?> test() {
        log.info("test");
        return ResponseEntity.ok("test");
    }
}

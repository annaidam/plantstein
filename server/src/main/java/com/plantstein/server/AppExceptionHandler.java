package com.plantstein.server;

import com.plantstein.server.exception.AlreadyExistsException;
import com.plantstein.server.exception.NotFoundException;
import io.swagger.v3.oas.annotations.Hidden;
import org.hibernate.cfg.NotYetImplementedException;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

/**
 * This class handles exceptions thrown by the rest controllers.
 * It returns a response consisting of the exception message and the corresponding status code.
 * <p>
 * This class is annotated with {@link RestControllerAdvice} to make it available to all rest controllers.
 * <p>
 * It is also annotated with {@link Hidden} to hide it from the API documentation,
 * otherwise there is an issue that results in all API routes being able
 * to throw those exceptions according to the documentation.
 */
@RestControllerAdvice
@Hidden
public class AppExceptionHandler extends ResponseEntityExceptionHandler {

    @ExceptionHandler(value = {AlreadyExistsException.class})
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    protected ResponseEntity<Object> handleAlreadyExists(AlreadyExistsException ex, WebRequest request) {
        return handleExceptionInternal(ex, ex.getMessage(),
                new HttpHeaders(), HttpStatus.BAD_REQUEST, request);
    }

    @ExceptionHandler(value = {NotFoundException.class})
    @ResponseStatus(HttpStatus.NOT_FOUND)
    protected ResponseEntity<Object> handleNotFound(NotFoundException ex, WebRequest request) {
        return handleExceptionInternal(ex, ex.getMessage(),
                new HttpHeaders(), HttpStatus.NOT_FOUND, request);
    }

    @ExceptionHandler(value = {NotYetImplementedException.class})
    @ResponseStatus(HttpStatus.NOT_IMPLEMENTED)
    protected ResponseEntity<Object> handleNotFound(NotYetImplementedException ex, WebRequest request) {
        return handleExceptionInternal(ex, ex.getMessage(),
                new HttpHeaders(), HttpStatus.NOT_IMPLEMENTED, request);
    }
}
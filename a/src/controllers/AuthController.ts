import { Request, Response } from 'express';
import { AuthService } from '../services/AuthService';
import { IUser } from '../models/User';

export class AuthController {
  static async register(req: Request, res: Response): Promise<void> {
    try {
      const { name, email, password } = req.body;

      console.log(`🔄 Registration attempt for: ${email}`);

      const { user, token } = await AuthService.register({
        name: name.trim(),
        email: email.trim().toLowerCase(),
        password
      });

      res.status(201).json({
        success: true,
        message: 'User registered successfully',
        data: {
          user: {
            id: user._id,
            name: user.name,
            email: user.email,
            createdAt: user.createdAt
          },
          token
        }
      });

    } catch (error: any) {
      console.error('❌ Registration controller error:', error);

      // Handle duplicate email error
      if (error.code === 11000 || error.message.includes('already exists')) {
        res.status(409).json({
          success: false,
          message: 'User with this email already exists',
          error: 'DUPLICATE_EMAIL'
        });
        return;
      }

      // Handle validation errors
      if (error.name === 'ValidationError') {
        const validationErrors = Object.values(error.errors).map((err: any) => ({
          field: err.path,
          message: err.message
        }));

        res.status(400).json({
          success: false,
          message: 'Validation failed',
          errors: validationErrors,
          error: 'VALIDATION_ERROR'
        });
        return;
      }

      res.status(500).json({
        success: false,
        message: 'Internal server error during registration',
        error: 'INTERNAL_ERROR'
      });
    }
  }

  static async login(req: Request, res: Response): Promise<void> {
    try {
      const { email, password } = req.body;

      console.log(`🔄 Login attempt for: ${email}`);

      const { user, token } = await AuthService.login({
        email: email.trim().toLowerCase(),
        password
      });

      res.status(200).json({
        success: true,
        message: 'Login successful',
        data: {
          user: {
            id: user._id,
            name: user.name,
            email: user.email,
            createdAt: user.createdAt
          },
          token
        }
      });

    } catch (error: any) {
      console.error('❌ Login controller error:', error);

      // Handle invalid credentials
      if (error.message.includes('Invalid email or password')) {
        res.status(401).json({
          success: false,
          message: 'Invalid email or password',
          error: 'INVALID_CREDENTIALS'
        });
        return;
      }

      res.status(500).json({
        success: false,
        message: 'Internal server error during login',
        error: 'INTERNAL_ERROR'
      });
    }
  }

  static async getProtected(req: Request, res: Response): Promise<void> {
    try {
      const user = req.user; // Set by auth middleware

      console.log(`🔄 Protected route accessed by: ${user?.email}`);

      res.status(200).json({
        success: true,
        message: 'Acesso autorizado',
        data: {
          message: 'Você acessou uma rota protegida com sucesso!',
          user: {
            userId: user?.userId,
            email: user?.email
          },
          timestamp: new Date().toISOString()
        }
      });

    } catch (error: any) {
      console.error('❌ Protected route error:', error);

      res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: 'INTERNAL_ERROR'
      });
    }
  }
}

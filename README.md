# AI Prompt Template Manager

A sophisticated Phoenix LiveView application that allows you to create and manage AI prompt templates with dynamic placeholders. Built with modern web technologies and best practices in mind.

## Features

- Create and manage prompt templates with real-time validation
- Support for dynamic placeholders: `[[today]]` and `[[model]]`
- Real-time template processing with error handling
- Clean, modern UI with Tailwind CSS animations and transitions
- Persistent storage using Elixir's :persistent_term
- Responsive grid layout supporting mobile and desktop views
- Copy to clipboard functionality for processed templates
- Form validation with helpful error messages
- Delete confirmation to prevent accidental template removal
- Flash messages for user feedback
- Graceful error handling throughout the application
- Comprehensive test coverage

## Technical Implementation

- **Phoenix LiveView**: Leverages real-time features without writing JavaScript
- **Tailwind CSS**: Utilizes utility-first CSS framework for modern, responsive design
- **Error Handling**: Comprehensive validation and error handling for all user inputs
- **State Management**: Uses :persistent_term for efficient in-memory storage
- **Modal System**: Custom modal implementation for forms and template processing
- **Responsive Design**: Mobile-first approach with grid system
- **Animations**: Smooth transitions and hover effects for better UX
- **Testing**: Extensive test suite with LiveView integration tests

## Testing

The application includes a comprehensive test suite that covers all major functionality:

### Test Structure

- **Integration Tests**: Full LiveView integration tests
- **Validation Tests**: Template and model name validation
- **State Management Tests**: Persistent storage tests
- **UI Interaction Tests**: Modal and form interaction tests
- **Error Handling Tests**: Validation and error message tests

### Running Tests

```bash
# Run all tests
mix test

# Run tests with coverage report
mix test --cover

# Run specific test file
mix test test/prompt_manager_web/live/template_live_test.exs

# Run tests with detailed output
mix test --trace
```

### Test Coverage

The test suite covers:
- Template creation and validation
- Template processing and placeholder replacement
- Error handling and validation messages
- UI interactions and state management
- Persistent storage operations

### Test Helpers

Custom test helpers are provided in `test/support/live_helpers.ex` to facilitate testing:
- Template creation helpers
- Flash message assertions
- LiveView interaction helpers
- Date formatting utilities

## Setup

1. Install dependencies:
```bash
mix deps.get
```

2. Start Phoenix server:
```bash
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Usage

1. **Creating Templates**
   - Click "New Template" button
   - Enter a name (3-50 characters)
   - Write your prompt template using available placeholders:
     - `[[today]]` - Will be replaced with current date
     - `[[model]]` - Will be replaced with specified model name
   - Form validation ensures all inputs are correct
   - Save to store template persistently

2. **Running Templates**
   - Click "Run" on any template
   - Enter the model name (2-30 characters)
   - View the processed prompt with replaced placeholders
   - Use the copy button to copy the processed template

3. **Managing Templates**
   - View all templates in a responsive grid layout
   - Delete templates with confirmation
   - Templates persist between server restarts

## Example Template

Name: "Daily Task Analysis"
```
Today ([[today]]) I want to analyze a task using [[model]] as my AI assistant.

Please help me break down the following task into smaller, manageable steps...
```

## Requirements

- Elixir 1.15 or later
- Phoenix 1.7 or later
- Node.js (for asset compilation)

## Development

The application showcases several Elixir and Phoenix best practices:

- Proper LiveView event handling
- Comprehensive error handling and validation
- Efficient state management
- Modern UI/UX design principles
- Responsive web design
- Persistent storage without a database

## Code Structure

- `lib/prompt_manager_web/live/template_live.ex`: Main LiveView module with all business logic
- `lib/prompt_manager_web/live/template_live.html.heex`: Template with modern UI components
- Validation functions for all user inputs
- Error handling for all operations
- Persistent storage implementation

## Future Enhancements

- Additional placeholder types
- Template categories and tags
- Export/import functionality
- Template sharing
- More sophisticated template processing options
- User accounts and authentication

# jump_prompt_manager

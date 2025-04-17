local home = os.getenv 'HOME'
local jdtls = require 'jdtls'
local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }

-- Find the root directory of the project
local root_dir = require('jdtls.setup').find_root(root_markers)
if not root_dir then
  print 'JDTLS: Could not find project root directory'
  return
end

-- Project specific workspace
local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = home .. '/.cache/jdtls/workspace/' .. project_name
vim.fn.mkdir(workspace_dir, 'p')

-- Get Java path from asdf
local java_cmd = vim.fn.trim(vim.fn.system 'asdf which java')
if java_cmd == '' or vim.v.shell_error ~= 0 then
  print "JDTLS: Failed to find Java with 'asdf which java'"
  return
end

-- Path to installed jdtls
local jdtls_path = home .. '/.local/share/nvim/mason/packages/jdtls'

-- Find the launcher jar file
local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
if launcher_jar == '' then
  print 'JDTLS: Could not find launcher jar. Make sure jdtls is installed via Mason'
  return
end

-- Configuration directory based on OS (macOS)
local config_dir = jdtls_path .. '/config_mac'

-- Configure the LSP
local config = {
  -- The command that starts the language server
  cmd = {
    java_cmd,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '-Xmx2g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    launcher_jar,
    '-configuration',
    config_dir,
    '-data',
    workspace_dir,
  },

  -- One dedicated LSP server & client per project
  root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  settings = {
    java = {
      home = java_cmd:gsub('/bin/java$', ''), -- Point to Java installation
      format = {
        enabled = true,
        settings = {
          url = home .. '/.config/nvim/language-servers/java-google-formatter.xml', -- Optional: path to formatter settings
          profile = 'GoogleStyle', -- Optional: formatter profile
        },
      },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
      completion = {
        favoriteStaticMembers = {
          'org.junit.Assert.*',
          'org.junit.Assume.*',
          'org.junit.jupiter.api.Assertions.*',
          'org.junit.jupiter.api.Assumptions.*',
          'org.junit.jupiter.api.DynamicContainer.*',
          'org.junit.jupiter.api.DynamicTest.*',
          'org.slf4j.LoggerFactory.getLogger',
        },
        filteredTypes = {
          'com.sun.*',
          'io.micrometer.shaded.*',
          'java.awt.*',
          'jdk.*',
          'sun.*',
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999, -- No star imports
          staticStarThreshold = 9999, -- No static star imports
        },
      },
      codeGeneration = {
        toString = {
          template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = {
          {
            name = 'JavaSE-21', -- Adjust to your Java version
            path = java_cmd:gsub('/bin/java$', ''),
            default = true,
          },
        },
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = 'all', -- literals, all, none
        },
      },
    },
  },

  -- Language server `initializationOptions`
  -- Add any necessary jar files for extensions such as debugging
  init_options = {
    bundles = {
      -- vim.fn.glob(home .. "/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar")
      -- Add more bundles if needed
    },
    extendedClientCapabilities = {
      progressReportProvider = true,
      classFileContentsSupport = true,
      generalCompletionSupport = true, -- AutoImport
      resolveAdditionalTextEditsSupport = true, -- AutoImport
    },
  },

  -- Enable Lombok support
  on_attach = function(client, bufnr)
    -- Customize key mappings here if desired
    -- Example:
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr })

    -- Enable Lombok support
    jdtls.setup_dap { hotcodereplace = 'auto' }

    -- Setup additional commands
    jdtls.setup.add_commands()

    -- Show project information
    print('JDTLS: Connected to project: ' .. project_name)
  end,

  -- Optional: Control which filetypes the Java LSP attaches to
  filetypes = { 'java' },

  -- Optional: Additional capabilities
  capabilities = vim.lsp.protocol.make_client_capabilities(),
}

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)

-- Add key mappings for Java-specific commands
vim.keymap.set('n', '<leader>jo', jdtls.organize_imports, { desc = 'Organize Imports' })
vim.keymap.set('n', '<leader>jv', jdtls.extract_variable, { desc = 'Extract Variable' })
vim.keymap.set('n', '<leader>jc', jdtls.extract_constant, { desc = 'Extract Constant' })
vim.keymap.set('n', '<leader>jm', jdtls.extract_method, { desc = 'Extract Method' })
vim.keymap.set('n', '<leader>jt', jdtls.test_class, { desc = 'Test Class' })
vim.keymap.set('n', '<leader>jn', jdtls.test_nearest_method, { desc = 'Test Nearest Method' })

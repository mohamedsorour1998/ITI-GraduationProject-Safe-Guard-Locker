const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();
// Enable CORS middleware
app.use(cors());
app.use(bodyParser.json());

const users = [];
let counter = 1;
let nextUserId = 1;

const availableLockers = [
  {
    id: "1",
    name: "Locker 1",
    size: "Small",
    price: 10.0,
    imageUrl: "https://m.media-amazon.com/images/I/51TuSJOwO1L._AC_UL320_.jpg",
    isAvailable: true,
    userId: null,
  },
  {
    id: "2",
    name: "Locker 2",
    size: "Medium",
    price: 20.0,
    imageUrl: "https://m.media-amazon.com/images/I/51s3ebenFDL._AC_UL320_.jpg",
    isAvailable: true,
    userId: null,
  },
];

const registerUser = async (email, password) => {
  const user = {
    id: nextUserId,
    email: email,
    password: password,
  };
  users.push(user);
  console.log(`Registered user:  ${email} with id ${user.id}`);
  nextUserId++;
};

const loginUser = async (email, password) => {
  console.log(
    `Trying to log in with email: ${email} and password: ${password}`
  );
  const user = users.find((u) => u.email === email);
  console.log(`User found: ${JSON.stringify(user)}`);
  if (!user) {
    return null;
  }

  const isPasswordValid = password === user.password;
  console.log(`User ${email} logged in: ${isPasswordValid}`);
  return isPasswordValid ? user.id : null;
};
app.get("/users/email/:email", async (req, res) => {
  try {
    const email = req.params.email;
    const user = users.find((u) => u.email === email);

    if (user) {
      res.status(200).json(user);
    } else {
      res.status(404).json({ message: "User not found" });
    }
  } catch (error) {
    console.error("Error fetching user by email:", error);
    res.status(500).json({ message: "Error fetching user by email" });
  }
});

app.post("/register", async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: "Email and password are required" });
  }

  await registerUser(email, password);
  res.status(200).json({ message: "User registered successfully" });
});

app.post("/login", async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: "Email and password are required" });
  }

  const userId = await loginUser(email, password);
  console.log(`userId after loginUser: ${userId}`);
  if (userId !== null) {
    console.log("Sending successful response");
    return res
      .status(200)
      .json({ message: "Login successful", userId: userId.toString() });
  } else {
    console.log("Sending error response");
    return res.status(401).json({ error: "Invalid email or password" });
  }
});

app.get("/available-lockers", (req, res) => {
  res.status(200).json(availableLockers);
});
app.patch("/lockers/:id", (req, res) => {
  const lockerId = req.params.id;
  const userId = req.body.userId;

  const locker = availableLockers.find((l) => l.id === lockerId);
  if (!locker) {
    return res.status(404).json({ error: "Locker not found" });
  }

  locker.isAvailable = false;
  locker.userId = userId;
  res.status(200).json({ message: "Locker reserved successfully", locker });
});

app.patch("/lockers/:id/unreserve", (req, res) => {
  const lockerId = req.params.id;

  const locker = availableLockers.find((l) => l.id === lockerId);
  if (!locker) {
    return res.status(404).json({ error: "Locker not found" });
  }

  locker.isAvailable = true;
  locker.userId = null;
  res.status(200).json({ message: "Locker unreserved successfully", locker });
});
app.get("/users/:id", (req, res) => {
  const userId = req.params.id;
  const user = users.find((u) => u.id === parseInt(userId, 10));

  if (!user) {
    return res.status(404).json({ error: "User not found" });
  }

  res.status(200).json({ email: user.email });
});
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
